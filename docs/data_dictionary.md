# Data Dictionary

All source records are synthetic.

## Source files

### `users.csv`

| Field | Type | Description |
| --- | --- | --- |
| `user_id` | integer | Synthetic user business identifier |
| `registration_date` | date | Simulated registration date |
| `region` | text | Australian state or territory code |
| `age_group` | text | Simulated age band |

### `daily_events_YYYY-MM-DD.csv`

| Field | Type | Description |
| --- | --- | --- |
| `event_id` | integer | Event business identifier |
| `user_id` | integer | User business identifier |
| `event_type` | text | `view`, `click`, or `purchase` |
| `event_timestamp` | timestamp | Simulated event time |
| `device` | text | `desktop`, `mobile`, or `tablet` |
| `channel` | text | Acquisition or referral channel |
| `session_id` | text | Synthetic session identifier |

### `daily_orders_YYYY-MM-DD.csv`

| Field | Type | Description |
| --- | --- | --- |
| `order_id` | integer | Order business identifier |
| `user_id` | integer | User business identifier |
| `order_timestamp` | timestamp | Simulated order time |
| `amount` | decimal | Order value in AUD |
| `currency` | text | Currency code; `AUD` in this dataset |
| `payment_method` | text | `card`, `paypal`, or `bank_transfer` |
| `status` | text | `paid`, `pending`, or `refunded` |

## Warehouse tables

| Table | Grain | Main purpose |
| --- | --- | --- |
| `dw.dim_users` | One row per user | User registration and segment attributes |
| `dw.dim_date` | One row per observed date | Calendar attributes for time analysis |
| `dw.dim_device` | One row per device | Standardised device lookup |
| `dw.dim_channel` | One row per channel | Standardised channel lookup |
| `dw.fact_events` | One row per event | User interactions with dimension keys |
| `dw.fact_orders` | One row per order | Order value and status with dimension keys |

## Analytics marts

| Table | Grain | Main measures |
| --- | --- | --- |
| `marts.fact_daily_funnel` | One row per date | Stage users and daily conversion ratios |
| `marts.fact_segment_funnel` | One row per region × age group | Segment stage users and conversion ratios |
| `marts.fact_ltv` | One row per registration month × region × age group | Users, observed paid revenue, and LTV proxy |

## Metric caveat

`marts.fact_ltv.ltv` is an observed-period revenue-per-registered-user measure. Because the dataset covers only seven days, it should be interpreted as an LTV proxy rather than a forecast of true customer lifetime value.
