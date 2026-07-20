Take a look at our single-label ML training dataset in the Google Sheet "train_manifest_v1", in the "ML Datasets" folder on Google Drive, and treat that sheet as the source of truth. I want to know how balanced the classes are before the next training run, because a model that nails the common classes and quietly whiffs on the rare ones is exactly what I'm trying to catch, even when overall accuracy looks fine. Work off the snapshot as it stood at 2026-07-16 12:00 Asia/Kolkata and ignore any edits made after that. The run we're prepping for is 2026-07-23 09:00 Asia/Kolkata. Every date is Asia/Kolkata. Use the connected Google Drive and Microsoft Teams plugins, and the existing Chrome session if it helps, or open a fresh one.

Only look at rows where "split" is "train". Use "sample_id" as the unique id and "label" as the class label. The whole thing assumes every valid sample has exactly one label, and part of your job is to actually confirm that, not take it on faith.

Before any math, make sure everything you need is there and reachable: the sheet, the fields above, the snapshot as of that timestamp, and the Teams channel "ML Data Quality" in the "Workflow test" team you'll post to. If anything's missing or you can't get to it, or there are no valid training rows once the cleaning below is done, stop and tell me exactly what's wrong. Don't post a half-finished or guessed report. If the numbers aren't trustworthy, post nothing.

Now the part that matters, because label data is never as clean as people claim. Do the cleaning in this exact order and count every row once, or the totals won't reconcile.

First, the single-label check, and keep it separate from duplicate rows. Treat a label cell as multi-label only when it actually holds two or more real labels split by a delimiter like a comma, semicolon, or pipe, or stored as a list. Don't read multiple labels into other stray punctuation. If any row is genuinely multi-label, stop the task and show me up to 10 example label cells with counts, no sample ids or contents. Separate rows for the same sample id with different labels are conflicts you handle later, not a reason to stop.

Second, canonicalize labels before comparing. Trim the ends, collapse internal runs of whitespace to one space, and compare case-insensitively. Anything identical after that is the same class. For the display name, use the spelling that shows up on the most valid rows, and if two tie, the one that sorts first alphabetically. If a class had two or more raw spellings collapse into it, report it with the variants and their counts, because that's usually a data-entry bug worth surfacing. A label that's empty after trimming is a blank-label row, handled below.

Third, build the valid set by running these checks in this order. Each bad row lands in the first bucket it hits and only that one, so nothing gets double-counted:

1. Split leakage. If a sample id shows up under more than one split value anywhere in the sheet, it's compromised. Drop it completely, its train rows included, and count it as leakage.
2. Blank label. Empty after trimming.
3. Malformed label. After trimming, a value with control characters, made entirely of punctuation, or an obvious placeholder like null, n/a, none, unknown, or tbd.
4. Conflicting label. A surviving sample id that appears on multiple train rows whose canonicalized labels don't all agree. Drop the whole id, don't pick a winner.

Report those four counts, each on its own line. After that, a sample id that appears more than once with labels that all agree once canonicalized is one valid sample.

If some rows genuinely can't be sorted by these rules, don't guess. Count them as "unresolved" on their own, and if any of them could tip a class across the 5% line or into a different priority, say so and mark those classes provisional. Guessing on a row that flips a class from safe to underrepresented is the exact mistake I'm trying to avoid.

Once you've got the clean set, count the total unique valid training samples. Then for every class work out its sample count, its share of the valid set, whether it's severely underrepresented, its data-collection priority, and how many more samples it needs to reach 5% of the current valid dataset.

Precision matters here and there's a trap in it, so read this twice. Every threshold and priority call runs off the full-precision share, not a rounded one. The two-decimal figure is display only. So a class at 4.9951% shows as 5.00% but is still under 5% and still counts as severely underrepresented. A class at exactly 5.000000% is not under. Same idea at the priority cut lines. Don't let a rounded number decide a bucket.

A class is severely underrepresented when its true share is under 5.00%. For the gap:

max(0, ceiling(0.05 x total valid samples) minus current class sample count)

Use exact integer math on that ceiling. Call the field "Samples Needed to Reach 5% of Current Dataset," and say in the report that it's a planning estimate off the 2026-07-16 snapshot size that has to be recalculated once new samples come in, because adding data moves the target.

Priorities, all judged on the true share:

- P0 for a class under 1.00%
- P1 from 1.00% up to but not including 2.50%
- P2 from 2.50% up to but not including 5.00%
- no priority at 5.00% or more

Rank the collection list by priority first, then lowest true share, then biggest sample gap. If two classes are within 0.01 percentage points and have the same gap, break the tie alphabetically by display label. Rank every class in the CSV the same way, no-priority ones after P2, numbered from 1.

Before you write anything out, reconcile it and put the ledger in the report so it's auditable. "Rows read" is every train row before exclusions; look at non-train rows only to catch leakage. Rows read has to equal leakage plus blank plus malformed plus conflict plus unresolved plus the rows that rolled up into valid samples. Per-class counts have to sum to the total valid sample count, and the class shares off the integer counts have to add to 100%, with only the displayed two-decimal figures allowed to drift from rounding. If any of that doesn't tie out, stop and tell me. Don't post a report that doesn't reconcile.

Build a CSV named "class_distribution_2026-07-16.csv" with every class in it, columns in exactly this order:

rank, priority, label, sample_count, dataset_share_pct, severely_underrepresented, samples_needed_to_5pct_current_size

Leave "priority" blank for no-priority classes, write "severely_underrepresented" as TRUE or FALSE, and write "dataset_share_pct" to two decimals with no percent sign.

Then post the imbalance report straight to the Teams channel "ML Data Quality" in the "Workflow test" team, posted for real, not a draft. Title it: "Training Data Imbalance Report - 2026-07-16"

The post needs to carry:
- the dataset location and snapshot timestamp
- the date and time of the next training run
- the total valid sample count
- the total number of class labels
- how many classes are below 5.00%, and what percent of classes that is
- the reconciliation ledger: rows read, and the leakage, blank, malformed, conflict, and unresolved counts
- any class that had multiple raw spellings collapse into it, with the variants
- the overall balance risk: HIGH if there's any P0 class, MEDIUM if there are P1 or P2 classes but no P0, LOW if nothing is below 5.00%
- the full priority list of severely underrepresented classes, with provisional ones flagged
- a straight recommendation on which classes should get new samples before the next run
- the full class-distribution CSV attached
- the note that the sample-gap estimates need recalculating after data collection

One catch on the threshold: if the dataset has more than 20 distinct classes, add a heads-up that they obviously can't all sit at 5% or more in a single-label set at once. Still find and rank the classes under 5%, just frame the 5% line as a prioritization signal there, not a hard bar every class has to clear.

Keep it clean and safe: no raw training records, no sample contents, no personal data, and no credentials anywhere in the message or the CSV.

One report per snapshot. Search the "ML Data Quality" channel for a post with this exact title and the snapshot timestamp 2026-07-16 12:00 Asia/Kolkata. If there's no match, post a new one. If there's exactly one, edit it in place and swap the CSV attachment. If there's more than one, stop and report the duplicates instead of posting again. A different timestamp is a different snapshot and gets its own report.

It's done when the channel holds exactly one report for this snapshot, the ledger reconciles, the CSV has every valid class, every class under 5.00% on true share shows up in the correctly sorted priority list with any provisional ones flagged, the collapsed-label groups and all exclusion counts are reported, and the report tells the ML team plainly which classes need more data before the next training run.
