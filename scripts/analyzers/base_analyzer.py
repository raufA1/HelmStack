#!/usr/bin/env python3
"""
Base analyzer interface for HelmStack
All analyzers should inherit from this base class
"""
import abc
from typing import Dict, List, Any
from pathlib import Path

class BaseAnalyzer(abc.ABC):
    """Base class for all document analyzers"""

    def __init__(self, name: str, description: str):
        self.name = name
        self.description = description

    @abc.abstractmethod
    def analyze(self, content: str, file_path: Path) -> Dict[str, Any]:
        """
        Analyze document content and return structured data

        Args:
            content: Raw file content
            file_path: Path to the source file

        Returns:
            Dictionary with analysis results:
            {
                'tasks': List[str],     # Extracted tasks
                'epics': List[str],     # Extracted epics
                'decisions': List[str], # Extracted decisions
                'risks': List[str],     # Identified risks
                'metrics': Dict[str, Any], # Analysis metrics
                'metadata': Dict[str, Any] # Additional data
            }
        """
        pass

    @abc.abstractmethod
    def supports_file_type(self, file_path: Path) -> bool:
        """Check if analyzer supports this file type"""
        pass

    def get_info(self) -> Dict[str, str]:
        """Get analyzer information"""
        return {
            'name': self.name,
            'description': self.description
        }