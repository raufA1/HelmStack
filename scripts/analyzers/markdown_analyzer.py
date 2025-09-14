#!/usr/bin/env python3
"""
Markdown analyzer - extracts structured data from markdown files
"""
import re
from pathlib import Path
from typing import Dict, List, Any
from .base_analyzer import BaseAnalyzer

class MarkdownAnalyzer(BaseAnalyzer):
    def __init__(self):
        super().__init__(
            name="markdown",
            description="Advanced markdown document analyzer"
        )

    def supports_file_type(self, file_path: Path) -> bool:
        return file_path.suffix.lower() in ['.md', '.markdown']

    def analyze(self, content: str, file_path: Path) -> Dict[str, Any]:
        """Analyze markdown content"""
        result = {
            'tasks': self._extract_tasks(content),
            'epics': self._extract_epics(content),
            'decisions': self._extract_decisions(content),
            'risks': self._extract_risks(content),
            'metrics': self._calculate_metrics(content),
            'metadata': {
                'file_type': 'markdown',
                'file_path': str(file_path),
                'headings': self._extract_headings(content)
            }
        }
        return result

    def _extract_tasks(self, content: str) -> List[str]:
        """Extract task items from markdown"""
        tasks = []
        lines = content.splitlines()
        current_context = ""

        for line in lines:
            # Track current section context
            if re.match(r'^#+\s+', line):
                current_context = re.sub(r'^#+\s+', '', line).strip()

            # Find task items
            task_match = re.match(r'^\s*[-*]\s+(.+)', line)
            checkbox_match = re.match(r'^\s*-\s*\[\s*\]\s+(.+)', line)

            if task_match or checkbox_match:
                task_text = (task_match or checkbox_match).group(1).strip()

                # Add priority markers
                priority = ""
                if "‼" in task_text:
                    priority = " ‼"
                elif "!" in task_text:
                    priority = " !"

                # Add context if available
                context_tag = ""
                if current_context and not current_context.lower().startswith(('status', 'summary', 'overview', 'notes')):
                    context_tag = f" @{current_context.replace(' ', '_').lower()}"

                full_task = f"- [ ] {task_text}{context_tag}{priority}"
                tasks.append(full_task)

        return tasks

    def _extract_epics(self, content: str) -> List[str]:
        """Extract epic headings"""
        epics = []
        for line in content.splitlines():
            if re.match(r'^##\s+Epic:\s*', line):
                epic_name = re.sub(r'^##\s+Epic:\s*', '', line).strip()
                epics.append(f"Epic: {epic_name}")
            elif re.match(r'^##\s+', line):
                heading = re.sub(r'^##\s+', '', line).strip()
                if not heading.lower().startswith(('status', 'summary', 'overview', 'notes', 'background', 'description')):
                    epics.append(f"Epic: {heading}")
        return epics

    def _extract_decisions(self, content: str) -> List[str]:
        """Extract decision points"""
        decisions = []
        lines = content.splitlines()

        for i, line in enumerate(lines):
            # Look for decision keywords
            decision_patterns = [
                r'(?i)we\s+(decided|choose|selected|agreed)',
                r'(?i)decision:\s*(.+)',
                r'(?i)(approved|rejected|postponed):\s*(.+)',
                r'(?i)consensus:\s*(.+)'
            ]

            for pattern in decision_patterns:
                match = re.search(pattern, line)
                if match:
                    context = self._get_surrounding_context(lines, i, 2)
                    decisions.append(f"Decision: {line.strip()} (Context: {context})")

        return decisions

    def _extract_risks(self, content: str) -> List[str]:
        """Extract risk indicators"""
        risks = []
        risk_keywords = [
            r'(?i)risk:\s*(.+)',
            r'(?i)concern:\s*(.+)',
            r'(?i)blocker:\s*(.+)',
            r'(?i)dependency:\s*(.+)',
            r'(?i)(might|could|may)\s+fail',
            r'(?i)unknown\s+(.+)',
            r'(?i)uncertain\s+(.+)'
        ]

        for line in content.splitlines():
            for pattern in risk_keywords:
                if re.search(pattern, line):
                    risks.append(f"Risk: {line.strip()}")

        return risks

    def _extract_headings(self, content: str) -> List[Dict[str, Any]]:
        """Extract heading structure"""
        headings = []
        for line_num, line in enumerate(content.splitlines(), 1):
            match = re.match(r'^(#+)\s+(.+)', line)
            if match:
                level = len(match.group(1))
                text = match.group(2).strip()
                headings.append({
                    'level': level,
                    'text': text,
                    'line': line_num
                })
        return headings

    def _calculate_metrics(self, content: str) -> Dict[str, Any]:
        """Calculate document metrics"""
        lines = content.splitlines()
        words = content.split()

        return {
            'lines': len(lines),
            'words': len(words),
            'chars': len(content),
            'headings': len([l for l in lines if re.match(r'^#+\s+', l)]),
            'tasks': len([l for l in lines if re.match(r'^\s*[-*]\s+', l)]),
            'checkboxes': len([l for l in lines if re.match(r'^\s*-\s*\[\s*\]\s+', l)]),
            'links': len(re.findall(r'\[.*?\]\(.*?\)', content)),
            'code_blocks': len(re.findall(r'```.*?```', content, re.DOTALL))
        }

    def _get_surrounding_context(self, lines: List[str], center: int, radius: int) -> str:
        """Get context around a specific line"""
        start = max(0, center - radius)
        end = min(len(lines), center + radius + 1)
        context_lines = lines[start:end]
        return " ".join(line.strip() for line in context_lines if line.strip())[:100]