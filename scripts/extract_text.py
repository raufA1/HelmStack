#!/usr/bin/env python3
"""
Text extraction utility for HelmStack
Converts DOCX and PDF files to markdown for processing
"""
import sys
import argparse
from pathlib import Path
from typing import Optional

def extract_from_docx(file_path: Path) -> Optional[str]:
    """Extract text from DOCX file"""
    try:
        # Try to import python-docx (optional dependency)
        from docx import Document

        doc = Document(file_path)
        paragraphs = []

        for para in doc.paragraphs:
            text = para.text.strip()
            if text:
                # Try to preserve some structure
                if para.style.name.startswith('Heading'):
                    level = '##' if '2' in para.style.name else '#'
                    paragraphs.append(f"{level} {text}")
                else:
                    paragraphs.append(text)

        return '\n\n'.join(paragraphs)

    except ImportError:
        return f"Error: python-docx not installed. Install with: pip install python-docx"
    except Exception as e:
        return f"Error extracting DOCX: {e}"

def extract_from_pdf(file_path: Path) -> Optional[str]:
    """Extract text from PDF file"""
    try:
        # Try to import PyPDF2 (optional dependency)
        import PyPDF2

        with open(file_path, 'rb') as file:
            reader = PyPDF2.PdfReader(file)
            text_parts = []

            for page_num, page in enumerate(reader.pages, 1):
                text = page.extract_text()
                if text.strip():
                    text_parts.append(f"## Page {page_num}\n\n{text.strip()}")

            return '\n\n'.join(text_parts)

    except ImportError:
        return f"Error: PyPDF2 not installed. Install with: pip install PyPDF2"
    except Exception as e:
        return f"Error extracting PDF: {e}"

def extract_text(file_path: Path, output_path: Optional[Path] = None) -> str:
    """Extract text from supported file formats"""
    if not file_path.exists():
        return f"Error: File not found: {file_path}"

    suffix = file_path.suffix.lower()

    if suffix == '.docx':
        content = extract_from_docx(file_path)
    elif suffix == '.pdf':
        content = extract_from_pdf(file_path)
    elif suffix in ['.md', '.txt']:
        try:
            content = file_path.read_text(encoding='utf-8')
        except Exception as e:
            content = f"Error reading text file: {e}"
    else:
        content = f"Error: Unsupported file format: {suffix}"

    if output_path:
        try:
            output_path.write_text(content, encoding='utf-8')
            print(f"✅ Extracted text written to: {output_path}")
        except Exception as e:
            print(f"❌ Error writing output: {e}")

    return content

def main():
    parser = argparse.ArgumentParser(description='Extract text from documents')
    parser.add_argument('input_file', help='Input file (PDF, DOCX, MD, TXT)')
    parser.add_argument('-o', '--output', help='Output markdown file')
    parser.add_argument('--print', action='store_true', help='Print extracted text')

    args = parser.parse_args()

    input_path = Path(args.input_file)
    output_path = Path(args.output) if args.output else None

    content = extract_text(input_path, output_path)

    if args.print or not output_path:
        print("=" * 50)
        print(f"Extracted from: {input_path}")
        print("=" * 50)
        print(content)

if __name__ == '__main__':
    main()