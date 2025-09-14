#!/usr/bin/env python3
"""
HelmStack Pluggable Analyzer System
Runs multiple analyzers on documents and combines results
"""
import sys
import json
import argparse
from pathlib import Path
from typing import Dict, List, Any, Optional

# Import analyzers
sys.path.append(str(Path(__file__).parent))
from analyzers.base_analyzer import BaseAnalyzer
from analyzers.markdown_analyzer import MarkdownAnalyzer
from analyzers.risk_analyzer import RiskAnalyzer
from analyzers.scope_analyzer import ScopeAnalyzer

class AnalyzerManager:
    def __init__(self):
        self.analyzers = [
            MarkdownAnalyzer(),
            RiskAnalyzer(),
            ScopeAnalyzer()
        ]

    def get_available_analyzers(self) -> List[str]:
        """Get list of available analyzer names"""
        return [analyzer.name for analyzer in self.analyzers]

    def analyze_file(self, file_path: Path, analyzer_names: Optional[List[str]] = None) -> Dict[str, Any]:
        """Analyze a single file with specified analyzers"""
        if not file_path.exists():
            return {'error': f"File not found: {file_path}"}

        try:
            content = file_path.read_text(encoding='utf-8')
        except Exception as e:
            return {'error': f"Could not read file: {e}"}

        results = {
            'file_path': str(file_path),
            'analyzers': {},
            'combined': {
                'tasks': [],
                'epics': [],
                'decisions': [],
                'risks': [],
                'metrics': {},
                'metadata': {}
            }
        }

        # Filter analyzers if specified
        analyzers_to_run = self.analyzers
        if analyzer_names:
            analyzers_to_run = [a for a in self.analyzers if a.name in analyzer_names]

        # Run analyzers
        for analyzer in analyzers_to_run:
            if analyzer.supports_file_type(file_path):
                try:
                    analysis = analyzer.analyze(content, file_path)
                    results['analyzers'][analyzer.name] = analysis

                    # Combine results
                    self._merge_results(results['combined'], analysis, analyzer.name)
                except Exception as e:
                    results['analyzers'][analyzer.name] = {'error': str(e)}

        return results

    def analyze_directory(self, directory: Path, analyzer_names: Optional[List[str]] = None) -> Dict[str, Any]:
        """Analyze all supported files in directory"""
        if not directory.exists():
            return {'error': f"Directory not found: {directory}"}

        results = {
            'directory': str(directory),
            'files': {},
            'summary': {
                'total_files': 0,
                'analyzed_files': 0,
                'total_tasks': 0,
                'total_risks': 0,
                'total_epics': 0,
                'analyzers_used': set()
            }
        }

        # Find all supported files
        supported_extensions = ['.md', '.txt', '.rst', '.adoc']
        files_to_analyze = []

        for ext in supported_extensions:
            files_to_analyze.extend(directory.glob(f"*{ext}"))
            files_to_analyze.extend(directory.glob(f"**/*{ext}"))

        results['summary']['total_files'] = len(files_to_analyze)

        # Analyze each file
        for file_path in files_to_analyze:
            file_results = self.analyze_file(file_path, analyzer_names)
            if 'error' not in file_results:
                results['files'][str(file_path.relative_to(directory))] = file_results
                results['summary']['analyzed_files'] += 1

                # Update summary
                combined = file_results['combined']
                results['summary']['total_tasks'] += len(combined['tasks'])
                results['summary']['total_risks'] += len(combined['risks'])
                results['summary']['total_epics'] += len(combined['epics'])
                results['summary']['analyzers_used'].update(file_results['analyzers'].keys())

        # Convert set to list for JSON serialization
        results['summary']['analyzers_used'] = list(results['summary']['analyzers_used'])

        return results

    def _merge_results(self, combined: Dict[str, Any], analysis: Dict[str, Any], analyzer_name: str):
        """Merge analysis results into combined results"""
        # Merge lists
        for key in ['tasks', 'epics', 'decisions', 'risks']:
            if key in analysis:
                combined[key].extend(analysis[key])

        # Merge metrics
        if 'metrics' in analysis:
            combined['metrics'][analyzer_name] = analysis['metrics']

        # Merge metadata
        if 'metadata' in analysis:
            combined['metadata'][analyzer_name] = analysis['metadata']

def main():
    parser = argparse.ArgumentParser(description='HelmStack Document Analyzer')
    parser.add_argument('path', help='File or directory to analyze')
    parser.add_argument('--analyzers', nargs='+', help='Specific analyzers to run')
    parser.add_argument('--output', '-o', help='Output file (JSON format)')
    parser.add_argument('--list-analyzers', action='store_true', help='List available analyzers')
    parser.add_argument('--format', choices=['json', 'summary'], default='summary', help='Output format')

    args = parser.parse_args()

    manager = AnalyzerManager()

    if args.list_analyzers:
        print("Available analyzers:")
        for analyzer in manager.analyzers:
            print(f"  {analyzer.name}: {analyzer.description}")
        return

    path = Path(args.path)

    if path.is_file():
        results = manager.analyze_file(path, args.analyzers)
    elif path.is_dir():
        results = manager.analyze_directory(path, args.analyzers)
    else:
        print(f"Error: Path not found: {path}")
        return

    # Output results
    if args.format == 'json':
        output = json.dumps(results, indent=2)
    else:
        output = format_summary(results)

    if args.output:
        Path(args.output).write_text(output, encoding='utf-8')
        print(f"Results written to: {args.output}")
    else:
        print(output)

def format_summary(results: Dict[str, Any]) -> str:
    """Format results as human-readable summary"""
    lines = []

    if 'file_path' in results:
        # Single file results
        lines.append(f"📄 Analysis: {results['file_path']}")
        lines.append("")

        combined = results['combined']
        lines.append(f"📋 Tasks found: {len(combined['tasks'])}")
        lines.append(f"🎯 Epics found: {len(combined['epics'])}")
        lines.append(f"⚠️  Risks found: {len(combined['risks'])}")
        lines.append(f"📊 Analyzers used: {', '.join(results['analyzers'].keys())}")

        if combined['risks']:
            lines.append("\n⚠️  Risk Summary:")
            for risk in combined['risks'][:5]:  # Show top 5 risks
                lines.append(f"  • {risk}")
            if len(combined['risks']) > 5:
                lines.append(f"  ... and {len(combined['risks']) - 5} more")

    else:
        # Directory results
        summary = results['summary']
        lines.append(f"📁 Analysis: {results['directory']}")
        lines.append("")
        lines.append(f"📄 Files analyzed: {summary['analyzed_files']}/{summary['total_files']}")
        lines.append(f"📋 Total tasks: {summary['total_tasks']}")
        lines.append(f"🎯 Total epics: {summary['total_epics']}")
        lines.append(f"⚠️  Total risks: {summary['total_risks']}")
        lines.append(f"🔧 Analyzers used: {', '.join(summary['analyzers_used'])}")

    return "\n".join(lines)

if __name__ == '__main__':
    main()