#!/usr/bin/env bash

for i in {1..10}; do
  i3-resurrect save -w "$i" --swallow=class,instance,title
done

i3-resurrect save -w __i3_scratch
