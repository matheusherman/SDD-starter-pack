## Business Rule – Pricing

Rule: Order pricing

Given:
  subtotal = X
  customerType = REGULAR | PREMIUM

Then:
  discount = if customerType == PREMIUM then X*0.10 else 0
  tax = (X - discount) * 0.08
  total = X - discount + tax
