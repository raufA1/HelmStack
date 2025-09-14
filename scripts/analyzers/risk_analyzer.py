#!/usr/bin/env python3
"""
Risk analyzer - identifies potential risks and blockers in documents
"""
import re
from pathlib import Path
from typing import Dict, List, Any
from .base_analyzer import BaseAnalyzer

class RiskAnalyzer(BaseAnalyzer):
    def __init__(self):
        super().__init__(
            name="risk",
            description="Risk and blocker identification analyzer"
        )

        # Risk patterns with severity levels
        self.risk_patterns = {
            'high': [
                r'(?i)\b(critical|urgent|blocker|emergency)\b',
                r'(?i)\b(fail|failure|broken|crash|down)\b',
                r'(?i)\b(security|vulnerability|exploit)\b',
                r'(?i)\b(data\s+loss|corruption)\b'
            ],
            'medium': [
                r'(?i)\b(risk|concern|issue|problem)\b',
                r'(?i)\b(dependency|depends\s+on)\b',
                r'(?i)\b(unknown|uncertain|unclear)\b',
                r'(?i)\b(might|may|could)\s+.*(fail|break|issue)',
                r'(?i)\b(technical\s+debt)\b',
                r'(?i)\b(performance|slow|timeout)\b'
            ],
            'low': [
                r'(?i)\b(note|consider|think\s+about)\b',
                r'(?i)\b(future|later|eventually)\b',
                r'(?i)\b(nice\s+to\s+have|optional)\b'
            ]
        }

    def supports_file_type(self, file_path: Path) -> bool:
        # Risk analyzer works with any text-based file
        return file_path.suffix.lower() in ['.md', '.txt', '.rst', '.adoc']

    def analyze(self, content: str, file_path: Path) -> Dict[str, Any]:
        """Analyze content for risks"""
        risks = self._identify_risks(content)
        dependencies = self._identify_dependencies(content)
        blockers = self._identify_blockers(content)

        return {
            'tasks': [],  # Risk analyzer doesn't extract tasks
            'epics': [],  # Risk analyzer doesn't extract epics
            'decisions': [],  # Risk analyzer doesn't extract decisions
            'risks': risks,
            'metrics': {
                'risk_score': self._calculate_risk_score(risks),
                'total_risks': len(risks),
                'dependencies': len(dependencies),
                'blockers': len(blockers)
            },
            'metadata': {
                'analyzer': 'risk',
                'dependencies': dependencies,
                'blockers': blockers,
                'risk_distribution': self._get_risk_distribution(risks)
            }
        }

    def _identify_risks(self, content: str) -> List[str]:
        """Identify risks with severity levels"""
        risks = []
        lines = content.splitlines()

        for line_num, line in enumerate(lines, 1):
            for severity, patterns in self.risk_patterns.items():
                for pattern in patterns:
                    if re.search(pattern, line):
                        risk_text = line.strip()
                        risks.append(f"[{severity.upper()}] Line {line_num}: {risk_text}")
                        break  # Avoid duplicate entries for same line

        return risks

    def _identify_dependencies(self, content: str) -> List[str]:
        """Identify dependencies"""
        dependencies = []
        dependency_patterns = [
            r'(?i)depends?\s+on\s+(.+)',
            r'(?i)requires?\s+(.+)',
            r'(?i)needs?\s+(.+)',
            r'(?i)blocked\s+by\s+(.+)',
            r'(?i)waiting\s+for\s+(.+)'
        ]

        for line in content.splitlines():
            for pattern in dependency_patterns:
                match = re.search(pattern, line)
                if match:
                    dependency = match.group(1).strip()
                    dependencies.append(f"Dependency: {dependency}")

        return dependencies

    def _identify_blockers(self, content: str) -> List[str]:
        """Identify blockers"""
        blockers = []
        blocker_patterns = [
            r'(?i)blocker:\s*(.+)',
            r'(?i)blocked\s+by\s+(.+)',
            r'(?i)cannot\s+proceed\s+(.+)',
            r'(?i)stuck\s+(.+)',
            r'(?i)waiting\s+for\s+(.+)'
        ]

        for line in content.splitlines():
            for pattern in blocker_patterns:
                match = re.search(pattern, line)
                if match:
                    blocker = match.group(1).strip()
                    blockers.append(f"Blocker: {blocker}")

        return blockers

    def _calculate_risk_score(self, risks: List[str]) -> float:
        """Calculate overall risk score (0-10)"""
        if not risks:
            return 0.0

        high_risks = len([r for r in risks if '[HIGH]' in r])
        medium_risks = len([r for r in risks if '[MEDIUM]' in r])
        low_risks = len([r for r in risks if '[LOW]' in r])

        # Weighted scoring
        score = (high_risks * 3) + (medium_risks * 2) + (low_risks * 1)
        max_score = len(risks) * 3  # If all were high risk

        normalized_score = (score / max_score) * 10 if max_score > 0 else 0
        return round(normalized_score, 2)

    def _get_risk_distribution(self, risks: List[str]) -> Dict[str, int]:
        """Get distribution of risk levels"""
        distribution = {'high': 0, 'medium': 0, 'low': 0}

        for risk in risks:
            if '[HIGH]' in risk:
                distribution['high'] += 1
            elif '[MEDIUM]' in risk:
                distribution['medium'] += 1
            elif '[LOW]' in risk:
                distribution['low'] += 1

        return distribution