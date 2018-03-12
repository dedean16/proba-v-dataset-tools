# Notes:
- Principal Component Analysis might be useful for finding important features for `[FILTER]`..?
- After registration, `[DELTA]` could use something like:
$$ \Delta_{pix} = \sigma^2_{frames} $$
or combined into a single value
$$ \Delta=\frac{1}{N}\sum_{all\,pix} \sigma^2_{frames} $$
(where \(N\) is the number of pixels).
