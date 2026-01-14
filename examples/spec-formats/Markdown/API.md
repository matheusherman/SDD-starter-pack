# Domain: Simple Shop

## API – Create Order

Endpoint: POST /api/orders

Input:
  items: array<{ productId: string, quantity: number }>
  customerType: REGULAR | PREMIUM

Output:
  orderId: string
  total: number

Rules:
  Quantity must be >= 1
  PREMIUM customers receive 10% discount
  Tax is 8%
