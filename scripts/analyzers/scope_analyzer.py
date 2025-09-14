#!/usr/bin/env python3
"""
Scope analyzer - estimates project scope and complexity
"""
import re
from pathlib import Path
from typing import Dict, List, Any
from .base_analyzer import BaseAnalyzer

class ScopeAnalyzer(BaseAnalyzer):
    def __init__(self):
        super().__init__(
            name="scope",
            description="Project scope and complexity estimation analyzer"
        )

        # Complexity indicators
        self.complexity_keywords = {
            'high': [
                r'(?i)\b(algorithm|optimize|performance|scalable)\b',
                r'(?i)\b(integration|api|database|security)\b',
                r'(?i)\b(real-time|streaming|concurrent)\b',
                r'(?i)\b(machine\s+learning|ai|neural)\b'
            ],
            'medium': [
                r'(?i)\b(interface|ui|frontend|backend)\b',
                r'(?i)\b(validation|testing|deployment)\b',
                r'(?i)\b(configuration|settings|admin)\b',
                r'(?i)\b(report|dashboard|analytics)\b'
            ],
            'low': [
                r'(?i)\b(display|show|list|form)\b',
                r'(?i)\b(basic|simple|standard)\b',
                r'(?i)\b(documentation|readme|help)\b'
            ]
        }

        # Effort estimation keywords
        self.effort_patterns = {
            'days': r'(?i)(\d+)\s*(day|days)',
            'weeks': r'(?i)(\d+)\s*(week|weeks)',
            'months': r'(?i)(\d+)\s*(month|months)',
            'hours': r'(?i)(\d+)\s*(hour|hours|hr|hrs)',
            'story_points': r'(?i)(\d+)\s*(point|points|sp)'
        }

    def supports_file_type(self, file_path: Path) -> bool:
        return file_path.suffix.lower() in ['.md', '.txt', '.rst']

    def analyze(self, content: str, file_path: Path) -> Dict[str, Any]:
        """Analyze content for scope and complexity"""
        tasks = self._extract_tasks_with_estimates(content)
        complexity = self._assess_complexity(content)
        estimates = self._extract_estimates(content)

        return {
            'tasks': [t['text'] for t in tasks],
            'epics': [],
            'decisions': [],
            'risks': [],
            'metrics': {
                'total_tasks': len(tasks),
                'complexity_score': complexity['score'],
                'estimated_effort': estimates['total_effort'],
                'scope_size': self._calculate_scope_size(tasks, complexity)
            },
            'metadata': {
                'analyzer': 'scope',
                'task_details': tasks,
                'complexity_breakdown': complexity,
                'effort_estimates': estimates,
                'scope_recommendation': self._get_scope_recommendation(tasks, complexity)
            }
        }

    def _extract_tasks_with_estimates(self, content: str) -> List[Dict[str, Any]]:
        """Extract tasks with complexity and effort estimates"""
        tasks = []
        lines = content.splitlines()
        current_section = ""

        for line_num, line in enumerate(lines, 1):
            # Track current section
            if re.match(r'^#+\s+', line):
                current_section = re.sub(r'^#+\s+', '', line).strip()

            # Find tasks
            task_match = re.match(r'^\s*[-*]\s+(.+)', line)
            if task_match:
                task_text = task_match.group(1).strip()

                task_info = {
                    'text': f"- [ ] {task_text}",
                    'line': line_num,
                    'section': current_section,
                    'complexity': self._estimate_task_complexity(task_text),
                    'effort': self._estimate_task_effort(task_text),
                    'keywords': self._extract_task_keywords(task_text)
                }
                tasks.append(task_info)

        return tasks

    def _assess_complexity(self, content: str) -> Dict[str, Any]:
        """Assess overall complexity"""
        complexity_scores = {'high': 0, 'medium': 0, 'low': 0}

        for level, patterns in self.complexity_keywords.items():
            for pattern in patterns:
                matches = len(re.findall(pattern, content))
                complexity_scores[level] += matches

        total_indicators = sum(complexity_scores.values())
        if total_indicators == 0:
            overall_score = 1  # Default low complexity
        else:
            weighted_score = (
                complexity_scores['high'] * 3 +
                complexity_scores['medium'] * 2 +
                complexity_scores['low'] * 1
            )
            overall_score = weighted_score / total_indicators

        return {
            'score': round(overall_score, 2),
            'distribution': complexity_scores,
            'total_indicators': total_indicators,
            'level': self._get_complexity_level(overall_score)
        }

    def _extract_estimates(self, content: str) -> Dict[str, Any]:
        """Extract effort estimates from content"""
        estimates = {}
        total_hours = 0

        for unit, pattern in self.effort_patterns.items():
            matches = re.findall(pattern, content)
            if matches:
                estimates[unit] = [int(m[0]) for m in matches]

                # Convert to hours for total calculation
                if unit == 'hours':
                    total_hours += sum(estimates[unit])
                elif unit == 'days':
                    total_hours += sum(estimates[unit]) * 8  # 8 hours per day
                elif unit == 'weeks':
                    total_hours += sum(estimates[unit]) * 40  # 40 hours per week
                elif unit == 'months':
                    total_hours += sum(estimates[unit]) * 160  # ~160 hours per month

        return {
            'estimates': estimates,
            'total_effort': f"{total_hours} hours" if total_hours > 0 else "Not estimated"
        }

    def _estimate_task_complexity(self, task_text: str) -> str:
        """Estimate complexity of individual task"""
        task_lower = task_text.lower()

        for level, patterns in self.complexity_keywords.items():
            for pattern in patterns:
                if re.search(pattern, task_text):
                    return level

        # Default based on task length and keywords
        if len(task_text) > 100 or any(word in task_lower for word in ['implement', 'develop', 'create', 'build']):
            return 'medium'

        return 'low'

    def _estimate_task_effort(self, task_text: str) -> str:
        """Estimate effort for individual task"""
        # Look for explicit estimates
        for unit, pattern in self.effort_patterns.items():
            match = re.search(pattern, task_text)
            if match:
                return f"{match.group(1)} {unit}"

        # Estimate based on complexity
        complexity = self._estimate_task_complexity(task_text)
        effort_map = {
            'low': '2-4 hours',
            'medium': '1-2 days',
            'high': '3-5 days'
        }

        return effort_map.get(complexity, 'Unknown')

    def _extract_task_keywords(self, task_text: str) -> List[str]:
        """Extract meaningful keywords from task"""
        # Simple keyword extraction
        keywords = []
        tech_words = re.findall(r'\b(api|ui|database|test|deploy|config|auth|security|performance)\b', task_text.lower())
        action_words = re.findall(r'\b(implement|create|build|develop|design|test|deploy|configure)\b', task_text.lower())

        keywords.extend(tech_words)
        keywords.extend(action_words)

        return list(set(keywords))

    def _calculate_scope_size(self, tasks: List[Dict], complexity: Dict) -> str:
        """Calculate overall scope size"""
        task_count = len(tasks)
        complexity_score = complexity['score']

        if task_count < 5 and complexity_score < 1.5:
            return 'Small'
        elif task_count < 15 and complexity_score < 2.5:
            return 'Medium'
        elif task_count < 30 and complexity_score < 3.0:
            return 'Large'
        else:
            return 'Extra Large'

    def _get_complexity_level(self, score: float) -> str:
        """Get complexity level from score"""
        if score >= 2.5:
            return 'High'
        elif score >= 1.5:
            return 'Medium'
        else:
            return 'Low'

    def _get_scope_recommendation(self, tasks: List[Dict], complexity: Dict) -> str:
        """Get scope management recommendation"""
        task_count = len(tasks)
        complexity_level = complexity['level']

        if task_count > 20 and complexity_level == 'High':
            return "Consider breaking into multiple phases/milestones"
        elif complexity_level == 'High':
            return "Allocate extra time for technical complexity"
        elif task_count > 15:
            return "Consider prioritizing tasks by value/impact"
        else:
            return "Scope appears manageable for single iteration"