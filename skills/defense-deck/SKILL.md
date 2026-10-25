---
name: defense-deck
description: Plan, build and rehearse a presentation that survives questions: PANEL (thesis, capstone) or DEMO (hackathon). Evidence-based visuals, verified citations, anticipated questions, demo fallback. Use for defenses, pitches, demo days, capstone presentations, slide decks for a project, or likely panel/judge questions.
---

# Defense deck

A deck that survives questions is built from evidence, not decoration. Everything on a slide is either a figure from the work, a claim with a checked source, or a live demonstration of the real system.

The deck itself is produced with the Slides artifact type or the `pptx` skill (whichever the session offers). This skill owns the content, the evidence and the rehearsal. Use `clarify` for every undecided fact; never invent results, numbers or sources.

## Step 0: Pick the mode (ask via clarify)

Also settle: time limit, audience and their expertise, who presents which part, format (projector 1280x720 or 1920x1080, remote), grading rubric if any, what must be shown live, and what is already finished.

| | PANEL | DEMO |
|---|---|---|
| Time | 10-30 min + long Q&A | 3-7 min, often one shot |
| Audience | Examiners probing method and claims | Judges scoring impact, clarity, working demo |
| Register | Academic: ruled tables, source line per slide | Plain, visual, one idea per slide |
| Risk | A weak claim or citation | The live demo failing |
| Core asset | Method, results, limitations | The system working on stage, plus a fallback |

## Story spine

- **PANEL:** problem and why it matters → what is known (verified literature) → gap → method → results → limitations stated plainly → contribution → future work.
- **DEMO:** one person with a real problem → what they do today → the product in action (the live flow) → why it works → what's next. Open with the problem, not the team or the tech stack.

One message per slide, written as a full-sentence title that states the takeaway. Few words on slides; detail goes in notes and backup slides.

## Evidence rules

- **Visuals come from the work itself:** its own figures, tables, measurements, diagrams and real product renders, laid out in the register of the field. No stock photos, icon-in-circle rows, generic gradients, or decorative filler. Test: blank out the text, could this deck belong to another project? Rework until it couldn't.
- **One meaning per accent colour** across the whole deck.
- **Regenerable images:** every screenshot and render comes from a re-run script (fixed viewport, fixed seeded state; transparent background for product renders). Store the capture command in the repo or notes. If the product changes, one command refreshes the deck.
- **Numbers are traceable:** each number on a slide maps to a file, run, or table. Put a source line on result slides.
- **State limitations yourself.** A named limitation earns more trust than a hidden one, and pre-empts the obvious question.
- **Citations count only when read:** a citation is verified only when the exact supporting text has been read in the source. Title pages, abstracts of unseen papers, catalogue entries and "it's a classic" do not count. If a source can't be opened by a legitimate route (open access, author copy, library), replace it with one you can. Keep a table: claim, source, page or sentence, how verified.
- **Scope the judgement:** when asking the audience to judge or verify something, isolate the exact span and say what is out of scope.

## Build process

1. **Fixed bar first.** Write the checklist and severity bar ("would a panel reject or seriously question this?") before reviewing. Review the whole deck once against it, rank findings, then report re-checks only as a diff.
2. **Outline → claims table → slides.** Each slide lists its claim, its evidence and its source.
3. **Capture scripts** for all product visuals (see `testing-standards` e2e scaffold for a headless browser setup).
4. **Render at the real size** (the projector's resolution and a laptop) and look: overflow, contrast measured from pixels, type readable from the back row.
5. **Speaker notes:** the sentence to say, the evidence behind it, and the transition.
6. **Backup slides:** method detail, extra results, definitions, limitations, anything a question might drag you into.

## PANEL: anticipated questions

Generate and rank questions in these families, with a one-paragraph answer for each tied to a slide or backup slide:

- Why this problem / why does it matter / who benefits?
- Why this method over alternatives? What did you not try and why?
- How do you know it works? Sample size, validity, baseline, how results could be wrong.
- What are the limitations and threats to validity?
- Ethics, privacy, safety (hand details to `secure-and-compliant`).
- What did each member contribute? What would you do differently?
- Terms and numbers: define every term on your slides without notes.

Rehearse: each presenter answers cold; tighten any answer that wanders; agree who fields which kind of question; practice "I don't know, here's how I'd find out".

## DEMO: show the system, plan for failure

- **Audience sees the system.** If the real interface is invisible (a text message on a basic phone, a device, a background job), show a large shared view of what the system received, understood and decided, plus an honest simulator that runs the same code.
- **Show the "should stay quiet" cases** (false alarms, bad input) as first-class scenarios, and explain each decision with the actual numbers.
- **Fallback is mandatory:** if the live channel (network, API, camera, SMS) fails, the fallback runs the same code on recorded or simulated input and says plainly that it's the fallback. Prepare it, rehearse the switch, keep a recorded video as last resort.
- **Rehearse the dead-air cases:** wifi down, API slow, device dead, projector resolution wrong. Time the full run twice with a stopwatch; trim to leave a margin.
- **From the back row,** can a judge tell what just happened and why?
- Anticipate judge questions: impact and users, what's real vs mocked (be honest), cost and feasibility, what's next, what happens when it fails.

## Final checks

- Every claim has evidence; every citation was read; every number traces.
- Slides readable at 1280x720; no overflow; contrast measured.
- Notes complete; backups ready; images regenerable by one command.
- Demo fallback tested. Timing under the limit.
- Questions list ranked and answered.

Log recurring mechanisms (not this project's incidents) to Observer afterward.
