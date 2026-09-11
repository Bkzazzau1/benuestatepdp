# PoliSphere Benue

A Flutter prototype for the **Benue State PDP Governorship Campaign & Situation Room**. This branch replaces the former constituency-oriented experience with a statewide command system covering campaign intelligence, field operations, historical election analysis, campaign trends, scenario forecasting, election readiness and election-day command.

## Prototype scope

- Command overview for 23 LGAs, 276 wards/registration areas and 5,102 polling units
- Historical Benue governorship analysis for 2015, 2019 and 2023
- Current-factor and campaign-challenge registry
- Campaign trend centre with source-quality warnings
- Transparent forecast/scenario page that does not invent win probabilities
- Situation Room with LGA operational layer and structured incident feed
- Field-network/readiness view
- Election-day agent, incident and unofficial result workflow
- Data provenance, audit and governance controls

## Historical baselines

The prototype currently includes these statewide governorship totals:

| Year | APC | PDP | Winner |
| --- | ---: | ---: | --- |
| 2015 | 422,932 | 313,878 | APC |
| 2019 | 345,155 | 434,473 | PDP |
| 2023 | 473,933 | 223,913 | APC |

Primary/credible references used during the overhaul:

- INEC 2019 Benue governorship result sheet: https://www.inecnigeria.org/wp-content/uploads/2019/10/BENUE-1.pdf
- INEC 2023 General Election Report: https://www.inecnigeria.org/wp-content/uploads/2024/02/2023-GENERAL-ELECTION-REPORT-1.pdf
- INEC 2023 observer briefing / registered-voter baseline: https://inecnigeria.org/wp-content/uploads/2023/02/INEC-BRIEFING-FOR-OBSERVERS-TO-THE-2023-GENERAL-ELECTION.pdf
- Channels Television 2015 Benue governorship result report: https://www.channelstv.com/2015/04/13/apcs-samuel-ortom-wins-benue-governorship-election/

Voter registration, polling-unit configuration and all live campaign indicators must be refreshed from current authoritative data before production use.

## Data rules

Historical totals are treated separately from prototype/demo operational metrics. Live momentum, readiness and field-coverage numbers shown in the current UI are demonstration values until connected to verified campaign feeds.

The production system should retain source, timestamp, geography and confidence for important metrics. Aggregate public-interest and campaign-operational analysis is supported; the platform should not build individual political-belief profiles or infer sensitive political preferences about private citizens.

Campaign-collected election-day result entries must always remain clearly labelled **unofficial** until the official result is declared by INEC.

## Run

```sh
flutter pub get
flutter run
```

The Benue experience uses Flutter SDK components only; no additional package is required for this prototype layer.

## Source structure

- `lib/main.dart` — application entry point
- `lib/benue/benue_app.dart` — responsive statewide command shell
- `lib/benue/pages.dart` — campaign, intelligence, trends, situation room and election-day pages
- `lib/benue/data.dart` — Benue LGAs, historical election baselines, factors and prototype trend data
- `lib/benue/widgets.dart` — shared dashboard components
- `test/widget_test.dart` — core Benue prototype widget coverage

The previous constituency-specific `lib/src/` implementation has been removed from this overhaul branch so the repository has a single active product architecture.
