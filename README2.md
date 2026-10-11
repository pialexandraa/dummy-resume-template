# Dummy resume template: design rationale, Harvard guidance and ATS parsing

A LaTeX resume template (`main.tex`) built around the guidance in Harvard's [College Guide to Creating a Strong Resume](https://careerservices.fas.harvard.edu/resources/create-a-strong-resume/#tips), published by the Harvard FAS Mignone Center for Career Success.

This document explains the design choices and what is, and is not, supported by sources. Statements that could not be verified are marked as such in the final section.

---

## 1. Harvard guidance and how the template applies it

The Harvard page gives rules about language, content and ordering. It does not prescribe fonts, colors or a resume page limit (the only page limit on the page is for cover letters: "no more than a single page"). Everything about typography and color below is therefore the author's own choice, not Harvard guidance.

Quotes in the table are taken verbatim from the page's "Quick Tips" section.

| Harvard guidance | How `main.tex` applies it | Status |
|---|---|---|
| Resume language should be "specific rather than general" and "active rather than passive" | Bullets open with action verbs and name concrete tools (Go, gRPC, PostgreSQL) | met |
| "Written to express not impress", "articulate rather than 'flowery'" | No taglines or self-description; bullets state what was done | met |
| "Fact-based (quantify and qualify)" | Metrics in most experience bullets (5M+ requests, 40% latency, 60% query time, 45% to 85% coverage, 10 hours per week) | partly: the mentoring, reading-group and several education bullets have no figures |
| "Written for people who / systems that scan quickly" | Single column, short bullets, consistent entry headers | met |
| Don't use personal pronouns | None present | met |
| Don't include a picture, age or gender; don't list references | None present | met |
| Don't "start each line with a date" | Dates sit at the right of each entry header | met |
| "Within headings, list information in reverse chronological order" | Experience, education and projects are each ordered most recent first | met |
| "Avoid information gaps such as a missing summer" | The sample dates leave about 17 months between Nimbus Dynamics (ends Apr 2015) and Pioneer Software (starts Oct 2016), and about 10 months between DataStream (ends Dec 2021) and Nexus (starts Nov 2022). The second overlaps the M.S. studies | not met in the sample data |
| "Don't abbreviate" | Technical acronyms (AWS, gRPC, CI/CD, HCI) and degree abbreviations (B.S., M.S.) are used | partly: justified for technical terms, but worth knowing the guidance exists |
| "Use consistent spacing, underlining, italics, bold, and capitalization" | One `\entry` macro formats every header | met |
| "Be sure that your formatting will translate properly if converted to a .pdf" | Output is a LaTeX-generated PDF | see section 4 for what was and was not tested |

### Action verbs

Harvard publishes a categorized action verb list. Checking the verbs that open bullets in `main.tex` against it:

* on the list: designed, developed, collaborated, created, authored, built, assisted, organized, coordinated, provided, optimized, implemented
* not on the list: architected, migrated, refactored

Using verbs outside the list is not a problem in itself. The list is a suggestion, not a requirement.

### Persona

The page asks that a resume "authentically represent who you are and what you have to offer". In this template the persona is built from the sample content: a backend engineer with a cognitive psychology minor, a summer school at the Santa Fe Institute, community activities and specific interests. This is a content choice by the author. The page text does not say anything about including an interests section.

---

## 2. Name, color and fonts

### Name

"Dummy" here is meant in the dumbass sense, not the placeholder sense. It is a deliberately cheeky anti-label on a product that is carefully built: a resume designed to get through ATS filters, including the ones that count years of experience per skill.

The joke is that the resume is dull on purpose. No color accents, no columns, no graphics, nothing for a parser to trip over. It looks like the dumbest possible resume, and that is exactly why it gets read. The name keeps the project light, quick to use and not too serious about itself.

On the word itself: "dummy" and "dumbass" share a root, "dumb", but one does not come from the other. "Dummy" is "dumb" plus "-y", attested in the 1590s for a mute person. "Dumbass" appears in the 1930s. The name borrows the cheeky register of the second, not its etymology.

### Color: soft charcoal

* The color is `RGB(26, 25, 24)`, defined as `softblack` in `main.tex`.
* Contrast against white is about 17.6:1, calculated with the WCAG relative luminance formula. Pure black on white is 21:1. Both are well above the 7:1 that WCAG sets for AAA-level normal text.
* The motivation is stylistic: a slightly softer tone than pure black. The claim that pure black causes eye strain is common but weakly evidenced, so it is not made here.
* Color has no effect on ATS parsing, since parsers read the text layer.

### Fonts: Raleway and Lato

* The pair comes from Debarghya Das's Deedy-Resume template, which uses Lato and Raleway.
* Here, Raleway sets the name and the section headings (bold small caps) and Lato sets the body text.
* The original Deedy template is compiled with XeLaTeX and `fontspec`. This template instead loads the `lato` and `raleway` packages and is written for pdfLaTeX (`T1` encoding).
* Harvard's cover letter advice is to use "the same font type and size" for resume and cover letter. This does not constrain the choice of typeface.

---

## 3. Layout and engineering stance

```latex
\documentclass[10pt,letterpaper]{article}
\usepackage[top=0.5in,bottom=0.5in,left=0.6in,right=0.6in]{geometry}
```

* single column, no images, no text boxes and no floating elements, which removes the usual causes of scrambled reading order in parsers
* each entry header uses one `\entry{...}{...}{...}{...}` macro built on `tabularx`, with the organization and role on the left and place and dates on the right
* margins of 0.5 in (top and bottom) and 0.6 in (sides) are tight, chosen to fit more content per page

### The case for LaTeX over Word

Harvard provides editable resume templates in Microsoft Word and Google Docs. While word processors are accessible, they present distinct drawbacks for technical applications:
* Word documents rely on implicit style engines, loose margin definitions, and cross-platform quirks (a file saved in Word on macOS can wrap lines or break pages differently when opened in Office 365 or LibreOffice).
* LaTeX is the academic standard for scientific publications because it provides deterministic typesetting: compiling the same source code produces the exact same document layout across platforms.
* Compiling to PDF directly via LaTeX gives full micro-typographic control over vertical spacing, exact point sizes, and line breaks, allowing for a compact, disciplined presentation.
* More importantly for automated screening, writing LaTeX directly gives transparent control over what happens in the background. You determine the exact structure and sequence of characters emitted into the PDF text layer, avoiding invisible table cells or hidden formatting tags that confuse ATS parsers.

### Against template over-engineering: the single-file stance

A prevalent practice among open-source LaTeX resume templates is excessive modularity. Many popular templates split a short resume across an entire directory tree: a custom `.cls` class file, separate style packages, and individual sub-files for each section (`experience.tex`, `education.tex`, `skills.tex`).

While separation of concerns is a standard software engineering principle for large software systems, applying it to a single-page document introduces needless friction:
* **Fragile build dependencies:** Custom class files frequently rely on specific compilation engines (such as requiring XeLaTeX solely to resolve local font paths) or obsolete package combinations that break across TeX distributions.
* **Macro opacity:** Deeply nested custom wrappers obscure how text is actually laid out, making minor adjustments to margins or spacing difficult.
* **Maintenance overhead:** Updating a single date or editing a bullet point requires opening and coordinating multiple files.

This template adopts the opposite stance: **a single, self-contained `main.tex` file**. It relies exclusively on standard, widely supported packages (`article`, `geometry`, `tabularx`, `titlesec`, `enumitem`, `xcolor`), sets up its entire layout in approximately 40 readable lines of configuration, and keeps all content in one place. It compiles immediately in standard environments (including Overleaf or local TeX installations) without requiring custom class files or external dependencies.

---

## 4. How applicant tracking systems process this resume

### What is established

* An ATS (applicant tracking system) converts an uploaded document into structured data: sections, roles, employers, dates and skills.
* Many ATS products license this parsing from specialist vendors, while others build their own. Textkernel (which absorbed the former Sovren) is one such vendor. Capabilities and what recruiters see differ by product.
* Textkernel's parser reports, for each skill, the total months of use and the last-used date, derived from the dates of the positions in which the skill was found.
* Date extraction and normalization (turning "Nov 2022 -- Present" into a date interval) is a real natural language processing task, called temporal expression extraction and normalization (TimeML and TIMEX3 are the standard annotation schemes).

### A simplified pipeline

The order and names of the stages differ between vendors. This is a general picture, not any one product's design.

```
file upload
    |
    v
text extraction and reading order
    |
    v
section detection (experience, education, skills)
    |
    v
entity extraction (titles, employers, locations, dates, skills)
    |
    v
date normalization ("Nov 2022 -- Present" -> interval)
    |
    v
skill-to-role association (which skills appear in which dated role)
    |
    v
profile aggregation (months per skill) and matching or search
```

### Where natural language processing is used

* entity extraction and section detection use statistical or neural models
* matching skills to a taxonomy (so that related terms count together) uses ontologies and, in newer products, embeddings or large language models
* the duration itself is plain date arithmetic once a skill is tied to a dated role

"Skill-experience mapping" and "temporal extraction" are descriptive labels. They are not standard product terms, apart from temporal expression extraction as described above.

### Worked example from this resume

Months are counted inclusively from the stated start month to the stated end month, with "Present" taken as October 2026. Vendors may count differently, and how overlapping roles are combined is vendor-specific.

| Skill | Roles whose `Skills:` line lists it | Months | Years |
|---|---|---|---|
| Python | Nexus (48), DataStream (35), Pioneer (8), Nimbus (3) | 94 | about 7.8 |
| JavaScript | FinTech (20), Nimbus (3) | 23 | about 1.9 |
| Go | Nexus (48) | 48 | 4.0 |

These totals grow with every month that "Present" moves forward.

### Why per-role skills lines help

A skill listed only in a separate skills section has no dated role attached, so a parser has nothing to compute a duration from. With a `Skills:` line inside each role (lines 71, 81, 91, 101 and 111 of `main.tex`), each technology sits next to a date range. Whether a given parser gives zero duration to skills outside any role is vendor-specific and was not verified.

### Other design choices that help

* common section names (Experience, Education) are the easiest for parsers to recognize, though no heading guarantees correct classification
* a consistent `Mon YYYY -- Mon YYYY` date format is easy to parse
* single-column text gives a simple reading order

### Not every ATS ranks automatically

Some systems rely mainly on recruiter review and keyword search, not on automatic scoring. This template makes the data easier to extract either way, but there is no evidence here of how any specific product would rank it.

---

## 5. Open items and what was not verified

* **Harvard sources:** the Harvard claims above come from the live web page text. The screenshot supplied shows the same guidance. The sample resume and templates linked from that page were not read.
* **Text extraction from the PDF:** untested. With pdfLaTeX and `T1` fonts, ligatures such as "fi" can extract incorrectly unless the document loads `cmap` or sets `\input{glyphtounicode}` and `\pdfgentounicode=1`. `main.tex` does neither. Check by copying text out of the PDF.
* **Table-based entry headers:** the `tabularx` rows should extract row by row, but this was not tested.
* **Combined headings:** "Projects and activities" and "Skills and interests" are less conventional than separate "Projects" and "Skills" headings. Parser behavior on them was not tested.
* **Sample data:** the GitHub address in the header (`ale654789302mercer-dev`) differs from the LinkedIn handle (`alexmercer-dev`), which looks like a typo.
* **Vendor behavior:** statements about how Textkernel computes skill duration come from a search summary of vendor documentation, not from the primary document. Behavior of other vendors was not checked.
