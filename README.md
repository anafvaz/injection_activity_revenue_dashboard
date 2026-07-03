# Injection Activity & Revenue Dashboard

Revenue and activity analysis across two musculoskeletal clinics, covering 12 months of injection data broken down by clinic, physician, and billing code.

Built with SQL (PostgreSQL) and Tableau.

Data is synthetic and AI-generated for portfolio purposes. The analytical approach reflects real operational healthcare analysis.



## The Problem

Clinic operations teams need visibility into where revenue is coming from, which clinics, which physicians, and which billing codes drive the most activity. Without that, it's hard to spot risks or understand what would happen if billing patterns changed.



## Key Findings

- **$3.6M total revenue** across 11,857 injections, averaging $304 per injection
- **Coastal Clinic generates 58% of revenue** vs **42% for Ridgeview**, a single-site dependency
- **Top two physicians account for a disproportionate share of revenue**,  a dependency risk if activity changed
- **MSK01 is the dominant billing code** at 41%, followed by MSK02 (35%) and MSK03 (24%)


## Recommendations
- Coastal Clinic generates 58% of revenue. If capacity or staffing changes there, the business feels it immediately, worth modelling the impact of a volume drop before it happens.
- If either of the top two physicians reduces activity or leaves, revenue drops significantly with no plan in place.
- MSK03 runs at 24% of procedures vs 41% for MSK01, investigate whether that gap reflects clinical reality or a documentation pattern.


## Dashboard 

https://public.tableau.com/app/profile/ana.vaz7019/viz/MSK_Injection/Dashboard1#1

<img width="2374" height="1360" alt="Dashboard 1 (6)" src="https://github.com/user-attachments/assets/c1e7cc1b-8bd3-41da-bdbb-e03c282b8dd7" />

## Tools: 

SQL (PostgreSQL) · Tableau
