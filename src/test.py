import polars as pl

d = {"a": [1, 2], "b": [3, 4]}

df = pl.DataFrame(d)

print(df.head())