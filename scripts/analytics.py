#!/usr/bin/env python3
"""
HelmStack Session Analytics
Analyzes snapshots and generates session statistics
"""
import os
import re
import json
import argparse
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Any, Optional

class SessionAnalytics:
    def __init__(self, snapshots_dir: str = "snapshots"):
        self.snapshots_dir = Path(snapshots_dir)

    def analyze_session(self, date: Optional[str] = None) -> Dict[str, Any]:
        """Analyze session for specific date or today"""
        target_date = date if date else datetime.now().strftime('%Y%m%d')

        snapshots = self._get_snapshots_for_date(target_date)
        if not snapshots:
            return {'error': f'No snapshots found for date {target_date}'}

        session_data = {
            'date': target_date,
            'snapshots_analyzed': len(snapshots),
            'time_span': self._calculate_time_span(snapshots),
            'file_changes': self._analyze_file_changes(snapshots),
            'commit_activity': self._analyze_commits(snapshots),
            'productivity_metrics': {},
            'focus_areas': [],
            'summary': {}
        }

        session_data['productivity_metrics'] = self._calculate_productivity(session_data)
        session_data['focus_areas'] = self._identify_focus_areas(session_data)
        session_data['summary'] = self._generate_summary(session_data)

        return session_data

    def analyze_trends(self, days: int = 7) -> Dict[str, Any]:
        """Analyze trends over multiple days"""
        end_date = datetime.now()
        start_date = end_date - timedelta(days=days-1)

        trends = {
            'period': f'{start_date.strftime("%Y-%m-%d")} to {end_date.strftime("%Y-%m-%d")}',
            'daily_stats': [],
            'averages': {},
            'trends': {},
            'recommendations': []
        }

        # Analyze each day
        for i in range(days):
            current_date = start_date + timedelta(days=i)
            date_str = current_date.strftime('%Y%m%d')
            daily_analysis = self.analyze_session(date_str)

            if 'error' not in daily_analysis:
                trends['daily_stats'].append(daily_analysis)

        if trends['daily_stats']:
            trends['averages'] = self._calculate_averages(trends['daily_stats'])
            trends['trends'] = self._identify_trends(trends['daily_stats'])
            trends['recommendations'] = self._generate_recommendations(trends)

        return trends

    def _get_snapshots_for_date(self, date: str) -> List[Path]:
        """Get all snapshots for a specific date"""
        pattern = f"snap-{date}-*.txt"
        snapshots = list(self.snapshots_dir.glob(pattern))
        return sorted(snapshots)

    def _calculate_time_span(self, snapshots: List[Path]) -> Dict[str, str]:
        """Calculate time span of session"""
        if not snapshots:
            return {}

        times = []
        for snapshot in snapshots:
            # Extract time from filename: snap-20250914-051245.txt
            match = re.search(r'snap-\d+-(\d{6})\.txt', snapshot.name)
            if match:
                time_str = match.group(1)
                hour = int(time_str[:2])
                minute = int(time_str[2:4])
                times.append(hour * 60 + minute)  # Convert to minutes

        if not times:
            return {}

        start_minutes = min(times)
        end_minutes = max(times)
        duration_minutes = end_minutes - start_minutes

        return {
            'start_time': f"{start_minutes//60:02d}:{start_minutes%60:02d}",
            'end_time': f"{end_minutes//60:02d}:{end_minutes%60:02d}",
            'duration': f"{duration_minutes//60}h {duration_minutes%60}m"
        }

    def _analyze_file_changes(self, snapshots: List[Path]) -> Dict[str, Any]:
        """Analyze file changes across snapshots"""
        all_changes = {
            'files_modified': set(),
            'lines_added': 0,
            'lines_removed': 0,
            'total_changes': 0,
            'file_types': {},
            'change_patterns': []
        }

        for snapshot in snapshots:
            changes = self._parse_snapshot_changes(snapshot)

            all_changes['files_modified'].update(changes.get('files', []))
            all_changes['lines_added'] += changes.get('additions', 0)
            all_changes['lines_removed'] += changes.get('deletions', 0)

            # Track file types
            for file_path in changes.get('files', []):
                ext = Path(file_path).suffix.lower()
                if ext:
                    all_changes['file_types'][ext] = all_changes['file_types'].get(ext, 0) + 1

        all_changes['files_modified'] = list(all_changes['files_modified'])
        all_changes['total_changes'] = all_changes['lines_added'] + all_changes['lines_removed']

        return all_changes

    def _parse_snapshot_changes(self, snapshot_path: Path) -> Dict[str, Any]:
        """Parse changes from a snapshot file"""
        changes = {'files': [], 'additions': 0, 'deletions': 0}

        try:
            content = snapshot_path.read_text(encoding='utf-8')

            # Look for git diff output
            if '## diff' in content:
                diff_section = content.split('## diff')[1] if '## diff' in content else ""

                # Count file changes
                files = re.findall(r'^\+\+\+ b/(.+)$', diff_section, re.MULTILINE)
                changes['files'].extend(files)

                # Count line additions/deletions
                additions = len(re.findall(r'^\+[^+]', diff_section, re.MULTILINE))
                deletions = len(re.findall(r'^-[^-]', diff_section, re.MULTILINE))

                changes['additions'] = additions
                changes['deletions'] = deletions

        except Exception as e:
            # If parsing fails, continue with empty changes
            pass

        return changes

    def _analyze_commits(self, snapshots: List[Path]) -> Dict[str, Any]:
        """Analyze commit activity"""
        commits = {
            'total_commits': 0,
            'commit_messages': [],
            'commit_frequency': {},
            'commit_types': {}
        }

        for snapshot in snapshots:
            try:
                content = snapshot.read_text(encoding='utf-8')

                # Look for git log section
                if '## last commits' in content:
                    log_section = content.split('## last commits')[1].split('##')[0] if '## last commits' in content else ""

                    # Parse commit messages
                    commit_lines = [line.strip() for line in log_section.split('\n') if line.strip() and not line.startswith('(')]

                    for commit_line in commit_lines:
                        if commit_line:
                            commits['commit_messages'].append(commit_line)

                            # Analyze commit type
                            if commit_line.startswith('feat'):
                                commits['commit_types']['feature'] = commits['commit_types'].get('feature', 0) + 1
                            elif commit_line.startswith('fix'):
                                commits['commit_types']['fix'] = commits['commit_types'].get('fix', 0) + 1
                            elif commit_line.startswith('chore'):
                                commits['commit_types']['chore'] = commits['commit_types'].get('chore', 0) + 1
                            else:
                                commits['commit_types']['other'] = commits['commit_types'].get('other', 0) + 1

            except Exception:
                continue

        commits['total_commits'] = len(set(commits['commit_messages']))  # Unique commits
        return commits

    def _calculate_productivity(self, session_data: Dict[str, Any]) -> Dict[str, Any]:
        """Calculate productivity metrics"""
        file_changes = session_data.get('file_changes', {})
        time_span = session_data.get('time_span', {})

        metrics = {
            'files_per_hour': 0,
            'changes_per_hour': 0,
            'productivity_score': 0,
            'efficiency_rating': 'Unknown'
        }

        # Calculate duration in hours
        duration_str = time_span.get('duration', '0h 0m')
        hours = 0
        if 'h' in duration_str:
            hours_match = re.search(r'(\d+)h', duration_str)
            minutes_match = re.search(r'(\d+)m', duration_str)
            hours = int(hours_match.group(1)) if hours_match else 0
            minutes = int(minutes_match.group(1)) if minutes_match else 0
            hours += minutes / 60

        if hours > 0:
            metrics['files_per_hour'] = len(file_changes.get('files_modified', [])) / hours
            metrics['changes_per_hour'] = file_changes.get('total_changes', 0) / hours

            # Calculate productivity score (0-10)
            base_score = min(metrics['changes_per_hour'] / 50, 5)  # Max 5 points for changes
            file_diversity = min(len(file_changes.get('file_types', {})), 3)  # Max 3 points for file diversity
            commit_bonus = min(session_data.get('commit_activity', {}).get('total_commits', 0), 2)  # Max 2 points for commits

            metrics['productivity_score'] = round(base_score + file_diversity + commit_bonus, 2)

            # Efficiency rating
            if metrics['productivity_score'] >= 8:
                metrics['efficiency_rating'] = 'Excellent'
            elif metrics['productivity_score'] >= 6:
                metrics['efficiency_rating'] = 'Good'
            elif metrics['productivity_score'] >= 4:
                metrics['efficiency_rating'] = 'Average'
            else:
                metrics['efficiency_rating'] = 'Below Average'

        return metrics

    def _identify_focus_areas(self, session_data: Dict[str, Any]) -> List[str]:
        """Identify main focus areas from session"""
        file_changes = session_data.get('file_changes', {})
        focus_areas = []

        # Analyze file types
        file_types = file_changes.get('file_types', {})
        for ext, count in sorted(file_types.items(), key=lambda x: x[1], reverse=True):
            if ext == '.py':
                focus_areas.append('Python Development')
            elif ext == '.md':
                focus_areas.append('Documentation')
            elif ext in ['.js', '.ts', '.jsx', '.tsx']:
                focus_areas.append('Frontend Development')
            elif ext in ['.sh', '.bash']:
                focus_areas.append('Scripting & Automation')
            elif ext in ['.yml', '.yaml', '.json']:
                focus_areas.append('Configuration')

        # Analyze file paths
        files_modified = file_changes.get('files_modified', [])
        for file_path in files_modified:
            path_lower = file_path.lower()
            if 'test' in path_lower:
                focus_areas.append('Testing')
            elif 'config' in path_lower or 'setup' in path_lower:
                focus_areas.append('Configuration')
            elif 'doc' in path_lower or 'readme' in path_lower:
                focus_areas.append('Documentation')

        return list(set(focus_areas[:5]))  # Top 5 unique focus areas

    def _generate_summary(self, session_data: Dict[str, Any]) -> Dict[str, str]:
        """Generate session summary"""
        productivity = session_data.get('productivity_metrics', {})
        file_changes = session_data.get('file_changes', {})
        time_span = session_data.get('time_span', {})

        summary = {
            'overall': f"Session lasted {time_span.get('duration', 'unknown duration')} with {productivity.get('efficiency_rating', 'unknown')} productivity",
            'activity': f"Modified {len(file_changes.get('files_modified', []))} files with {file_changes.get('total_changes', 0)} total changes",
            'focus': f"Primary focus areas: {', '.join(session_data.get('focus_areas', ['General development'])[:3])}"
        }

        return summary

    def _calculate_averages(self, daily_stats: List[Dict]) -> Dict[str, float]:
        """Calculate average metrics across days"""
        if not daily_stats:
            return {}

        total_files = sum(len(day.get('file_changes', {}).get('files_modified', [])) for day in daily_stats)
        total_changes = sum(day.get('file_changes', {}).get('total_changes', 0) for day in daily_stats)
        total_score = sum(day.get('productivity_metrics', {}).get('productivity_score', 0) for day in daily_stats)

        return {
            'avg_files_per_day': round(total_files / len(daily_stats), 2),
            'avg_changes_per_day': round(total_changes / len(daily_stats), 2),
            'avg_productivity_score': round(total_score / len(daily_stats), 2)
        }

    def _identify_trends(self, daily_stats: List[Dict]) -> Dict[str, str]:
        """Identify trends in productivity"""
        if len(daily_stats) < 2:
            return {}

        scores = [day.get('productivity_metrics', {}).get('productivity_score', 0) for day in daily_stats]

        # Simple trend analysis
        first_half = scores[:len(scores)//2]
        second_half = scores[len(scores)//2:]

        first_avg = sum(first_half) / len(first_half) if first_half else 0
        second_avg = sum(second_half) / len(second_half) if second_half else 0

        trend = "stable"
        if second_avg > first_avg * 1.1:
            trend = "improving"
        elif second_avg < first_avg * 0.9:
            trend = "declining"

        return {
            'productivity_trend': trend,
            'trend_description': f"Productivity is {trend} over the analyzed period"
        }

    def _generate_recommendations(self, trends: Dict[str, Any]) -> List[str]:
        """Generate recommendations based on trends"""
        recommendations = []

        averages = trends.get('averages', {})
        trend_info = trends.get('trends', {})

        avg_score = averages.get('avg_productivity_score', 0)

        if avg_score < 4:
            recommendations.append("Consider breaking tasks into smaller, more manageable chunks")
            recommendations.append("Focus on one area at a time to improve efficiency")
        elif avg_score < 6:
            recommendations.append("Good progress! Try to maintain consistent work patterns")
        else:
            recommendations.append("Excellent productivity! Consider sharing your workflow with others")

        if trend_info.get('productivity_trend') == 'declining':
            recommendations.append("Productivity seems to be declining - consider taking breaks or reviewing priorities")
        elif trend_info.get('productivity_trend') == 'improving':
            recommendations.append("Great improvement trend! Keep up the good work")

        return recommendations

def main():
    parser = argparse.ArgumentParser(description='HelmStack Session Analytics')
    parser.add_argument('--date', help='Analyze specific date (YYYYMMDD)')
    parser.add_argument('--trends', type=int, metavar='DAYS', help='Analyze trends over N days')
    parser.add_argument('--output', '-o', help='Output file (JSON format)')
    parser.add_argument('--format', choices=['json', 'summary'], default='summary', help='Output format')

    args = parser.parse_args()

    analytics = SessionAnalytics()

    if args.trends:
        results = analytics.analyze_trends(args.trends)
    else:
        results = analytics.analyze_session(args.date)

    # Output results
    if args.format == 'json':
        output = json.dumps(results, indent=2)
    else:
        output = format_analytics_summary(results)

    if args.output:
        Path(args.output).write_text(output, encoding='utf-8')
        print(f"Analytics written to: {args.output}")
    else:
        print(output)

def format_analytics_summary(results: Dict[str, Any]) -> str:
    """Format analytics as human-readable summary"""
    lines = []

    if 'daily_stats' in results:
        # Trends analysis
        lines.append(f"📊 Productivity Trends: {results['period']}")
        lines.append("")

        averages = results.get('averages', {})
        lines.append(f"📈 Average files per day: {averages.get('avg_files_per_day', 0)}")
        lines.append(f"📈 Average changes per day: {averages.get('avg_changes_per_day', 0)}")
        lines.append(f"📈 Average productivity score: {averages.get('avg_productivity_score', 0)}/10")
        lines.append("")

        trends = results.get('trends', {})
        if trends:
            lines.append(f"📈 Trend: {trends.get('trend_description', 'No trend data')}")
            lines.append("")

        recommendations = results.get('recommendations', [])
        if recommendations:
            lines.append("💡 Recommendations:")
            for rec in recommendations:
                lines.append(f"  • {rec}")
    else:
        # Single session analysis
        if 'error' in results:
            lines.append(f"❌ {results['error']}")
        else:
            lines.append(f"📊 Session Analysis: {results['date']}")
            lines.append("")

            time_span = results.get('time_span', {})
            lines.append(f"⏱️  Duration: {time_span.get('duration', 'Unknown')}")
            lines.append(f"📄 Snapshots: {results.get('snapshots_analyzed', 0)}")

            productivity = results.get('productivity_metrics', {})
            lines.append(f"📈 Productivity Score: {productivity.get('productivity_score', 0)}/10 ({productivity.get('efficiency_rating', 'Unknown')})")
            lines.append("")

            summary = results.get('summary', {})
            for key, value in summary.items():
                lines.append(f"• {value}")

    return "\n".join(lines)

if __name__ == '__main__':
    main()