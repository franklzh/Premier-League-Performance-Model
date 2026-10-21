# Analyzing Premier League Season Points
## A Multi-Factor Regression Analysis of xG, xGA, PPDA, Possession, and Wage Bill

**Author:** Frank Lu

> This single-file report preserves the wording, numerical results, tables, figure captions, and explanations from the original paper. The figures are embedded as Markdown image references, so keep this file in the same repository as the `images/` folder.
Analyzing Premier League Season Points:

A Multi-Factor Regression Analysis of xG, xGA, PPDA, Possession, and Wage Bill

Frank Lu

1. Introduction and Literature Review

In professional European football, the question of what truly separates champions from also-rans has occupied the minds of coaches, and analysts alike. Winning and losing is the simple measure of success; however, beyond the wins and losses, a great amount of statistical measures can be made sense of with the help of modern sports analytics. This study investigates the following research question: How do offensive chance creation (xG), defensive vulnerability (xGA), pressing intensity (PPDA), ball possession, and squad wage bill collectively predict a Premier League team’s total point in a season? In this research, a multiple linear regression model is developed using a multi-season data set of English Premier League (EPL) team-seasons that spans 2017-2024 to determine the relative contributions of each predictor in influencing league table results, along with whether or not there is evidence that teams play their defense differently at home compared to on the road.

The English Premier League is the most-watched domestic league in terms of viewership and earning potential. The gap between finishing in the top four in the EPL table and being in the middle range is more than simply pride; it also means millions of pounds from UEFA prize money and television payouts, as well as additional negotiating power when acquiring players. Determining which team behavior variables can be measured to accurately predict points won has become a critical issue that must be addressed both by academics studying the problem and by sports directors and clubs' data scientists. The available research on the subject of using a multivariate regression model for predicting season points for the EPL seasons is surprisingly scarce, considering the demand for such information.

The concept of expected goals (xG) is the core of this study. Rather than simply counting goals scored, xG gives a probability to each shot based on its characteristics, including its distance from goal, angle, whether it was a header, and the quality of the preceding pass, to estimate how many goals a team should have scored given the quality of chances it generated. If a particular shooting situation occurred 100 times, how often would the team score? A 25-yard shot might receive an xG of 0.05, while a penalty carries an xG of 0.79. The parallel metric, expected goals against (xGA), applies the same logic to chances conceded, producing a shot-quality-adjusted measure of defensive vulnerability. Together, these two metrics removes the noise introduced by goalkeeper heroics, post-hitting misfortune, and the random variation that torment raw goal totals across a 38-match season.

There is substantial research support in academic literature on using xG and xGA for predicting team outcomes. Specifically, in a 2024 paper written by Xinyao Li and published with Atlantis Press, an investigation of tactics and statistics of EPL teams, including xG, xGA, and pressing intensities, was conducted. This research revealed that Manchester City and Liverpool teams kept constant aggressive pressing style along with high levels of xG, indicating that offense level and pressing intensity work together. In another study available on arXiv in 2024 (OpenFPL), models using xG, xGA, and PPDA from Understat dataset showed competitive forecasting abilities compared to professional platforms and were used during four EPL seasons between 2020 and 2024.

The third key predictor in this model is PPDA, or Passes Per Defensive Action. First introduced by analyst Colin Trainor in 2014, PPDA measures how many passes a team allows the opponent before making a defensive action, include ng fouls, interceptions, won duels, and tackles, measured only within the final 60% of the pitch. A lower PPDA indicates more aggressive high pressing. The 2024–25 Premier League season continued a multi-year trend of rising pressing intensity league-wide, with Liverpool leading the index at a league-low average PPDA of 9.89 under manager Arne Slot. While PPDA has gained traction as a tactical descriptor, its independent contribution to season-level points, after controlling for chance quality via xG and xGA, has not been rigorously isolated in a multi-season regression framework.

Possession percentage makes up the fourth variable of the model. In football, possession was always associated with territory control and was considered one of the main objectives on the pitch. With the increase in the number of teams that employ counterattacking tactics, however, the correlation between possession and wins has become more complex. The inclusion of possession in the model, together with xG and PPDA, will help establish whether possession by itself predicts results.

The fifth predictor, squad salary, adds a financial aspect to the model. The relationship between salaries and success in the English Premier League is well understood: player expenditure correlates positively with success. According to the work of Hall, Szymanski, and Zimbalist in sports economics, Granger causality was found to exist between larger payrolls and higher performance in English football. But there are clubs that succeed far beyond expectations based on the salaries, whereas there are those which waste money, yet their squads perform below expectations due to high salaries. Thus, it could be argued that the wage bill is not the best predictor of success. The inclusion of salary with other performance factors such as expected goals and possession rate will test if salary can be used independently from other performance factors as a predictor of success. Stanford University researchers Veliz et al. (2025) proved the feasibility of combining FBref and Transfermarkt databases.

Either previous studies have not looked at total team season points but focused on individual player value, looked at only a single season or two, or were very limited in terms of looking at only one or two predictor variables. The current research has not found any previous study published freely where the above four performance statistics have been used along with the fifth variable related to finances to forecast total points in a multiple seasons regression model.

2. Data and Methodology

This study draws on four publicly available data sources, integrated into a single team-season dataset covering seven English Premier League seasons from 2017–18 through 2023–24. The unit of observation is a team-season pair: one row per club per season. This yields a theoretical population of 140 observations before any exclusions for missing data.

### Data Sources

The primary source for team-level performance statistics is FBref (Sports Reference LLC), which provides downloadable CSV files of squad-level metrics including xG, xGA, possession percentage, progressive passes, and PPDA across all Premier League seasons. FBref compiles its data from Opta, one of the most widely used and verified event-data providers in professional football, which gives strong credibility to the performance metrics used here.

The second source, Understat.com, offers season-level xG and xGA data organized by team, and serves as a cross-validation reference to verify the consistency of FBref's xG figures, particularly for earlier seasons where minor methodological differences between providers can produce small discrepancies.

Squad wage bill data is sourced from Capology.com, a site that collects and estimates annual player salary figures for professional clubs, and from a mirrored Kaggle dataset (d2ski/football-transfers-data) that aggregates Transfermarkt and Capology records. Annual totals are standardized to millions of British pounds (£m) per season to allow comparison across years (inflation across the time period is neglected for simplicity). A fourth source, the Kaggle dataset compiled by Daniel Ijezie (Premier League Data 2016–2024), provides a complementary set of match results and team standings used to verify final points totals for each team-season.

### Variables

The response variable is total season points (Y), defined as the cumulative league points a club earned across all 38 matches in a given season, ranging practically from approximately 30 to 97. The five predictor variables are: xG (season total expected goals for, in decimal goal units), xGA (season total expected goals against, in decimal goal units), PPDA (passes per defensive action, a unitless ratio where lower values indicate more aggressive pressing), possession percentage (average share of in-game ball time per season, expressed as a percentage), and squad wage bill (total annual player wage expenditure per club, in £ millions). xG and possession are expected to carry positive coefficients, xGA and PPDA negative coefficients, and wage bill a positive but potentially diminishing relationship with points.

### Data Collection and Integration

All four sources were downloaded or accessed as CSV files. Integration was performed in R, with "team_name" and "season_year" as the composite key linking records across datasets. Wage bill figures were standardized to a consistent annual £m denomination. Before joining, xG and xGA values from FBref and Understat were compared at the team-season level and flagged if discrepancies exceeded the defined threshold. Any team-season observation with missing values across one or more predictors was excluded from the dataset prior to sampling.

### Sampling Method

Because the full population of 140 team-season observations is itself relatively modest, a random sample of approximately 80–100 observations was drawn to ensure reproducibility. This sample size comfortably exceeds the commonly recommended minimum of at least 10–20 observations per predictor for stable multiple regression estimation with five predictors, and random sampling guards against inadvertently over-representing dominant clubs or specific competitive eras.

### Limitations

First, wage bill statistics collected from Capology are partially estimated since salaries of some players are not disclosed by their teams. Secondly, PPDA stats are not always consistent across different data sources, especially for seasons prior to 2019/20 because tracking data was more incomplete. Thirdly, focusing the sample only on seven seasons and twenty teams narrows down the sample size and, thus, weakens the model’s ability to identify small effects on variables such as possession, since the connection between them and points has been declining over time. Lastly, all data is gathered before the season commences.

3. Exploratory Data Analysis

The exploratory data analysis examines the 90-observation random sample drawn from the full population of 140 English Premier League team-season records spanning 2017–18 through 2023–24. The goal of this section is to characterize the distribution of season and to investigate the bivariate relationships between each of the five predictors and the outcome before formal modeling.

### Summary Statistics

Table 1 presents the summary statistics for all key variables in the sample. Season points range from a low of 16 to a high of 100, earned by Manchester City in 2017–18, with a mean of 51.59 points (SD = 18.65). This wide spread shows the nature of Premier League competition, in which elite clubs consistently accumulate 80 or more points per season and relegated sides routinely finish below 35. The interquartile range (IQR) of 21.75 points (Q1 = 40.0, Q3 = 61.75) indicates that roughly half of all team-seasons cluster in a moderately competitive range just above or below the 50-point mark that historically represents a safe mid-table finish.

Expected goals scored (xG) has a mean of 52.64 (SD = 17.38) and closely mirrors the distribution of points, which signals its predictive strength in the regression model. Expected goals conceded (xGA) averages 58.11 (SD = 13.21) per season. The tighter dispersion of xGA relative to xG suggests that defensive performances across Premier League clubs are somewhat more homogeneous than offensive output. PPDA, the pressing intensity metric, averages 12.26 passes per defensive action (SD = 2.93), with aggressive high-pressing sides recording values as low as 6.2 and passive deep-block teams reaching 18.3. Possession averages 48.69% (SD = 8.15) and wage bill ranges from £48 million to £377 million per season, capturing the enormous financial discrepency of the division.

**Table 1: Summary Statistics — EPL Sample (n = 90)**

|Variable|Min|Q1 (25th %)|Median|Mean|Q3 (75th %)|Max|SD|
|---|---|---|---|---|---|---|---|
|Season Points|16|40.0|49.0|51.59|61.75|100|18.65|
|xG (Exp. Goals For)|25.0|41.0|51.5|52.64|61.7|102.0|17.38|
|xGA (Exp. Goals Ag.)|21.0|52.0|58.3|58.11|67.5|83.5|13.21|
|PPDA|6.2|9.85|12.30|12.26|14.20|18.30|2.93|
|Possession (%)|34.2|42.6|48.9|48.69|54.7|67.8|8.15|
|Wage Bill (£m)|48|85.25|109.0|136.51|174.0|377|76.74|

All monetary figures in millions of British pounds (£m). PPDA = passes per defensive action.

### Distribution of the Response Variable

Figure 1 displays the distribution of season points across the 90-observation sample. The distribution is approximately unimodal and slightly right-skewed, with the peak occurring between 40 and 55 points. The mean (51.59 points, shown as a dashed red line) is close to the median (49.0 points), which means only modest skewness. Two clubs appear as outliers in the upper tail — Manchester City's 100-point season and Liverpool's 97-point season in 2018–19, reflecting the dominance of the top two clubs in this era. The relatively symmetric shape of the distribution suggests that ordinary least squares regression is an appropriate modeling framework for this response variable.


**Figure 1: Histogram of season points (n = 90).**

![Figure 1: Histogram of season points (n = 90).](images/figure-01.png)
Figure 2 plots season xG against final points and reveals the strongest bivariate relationship in the dataset, with a Pearson correlation of r = 0.948. The linear trend is steep and consistent across all seven seasons, indicating that teams generating more expected goals reliably accumulate more points regardless of the competitive year. This tight relationship suggests xG is likely the most influential predictor in the regression model. Observations near the regression line include a broad mix of seasons and clubs, which supports the robustness of the relationship rather than it being season-specific.


**Figure 2**

![Figure 2](images/figure-02.png)
Figure 3 displays the relationship between expected goals against (xGA) and season points. The correlation is strongly negative (r = −0.924), confirming that teams conceding more high-quality scoring opportunities finish with substantially fewer points. The trend is nearly as strong as that of xG, indicating that defensive performance is approximately as informative as offensive output when predicting final standings. Notably, the elite defensive records belong to Manchester City and Liverpool across multiple seasons, whose xGA totals remain well below 40 in their championship seasons.


**Figure 3: Scatter plot of season xGA vs. season points.**

![Figure 3: Scatter plot of season xGA vs. season points.](images/figure-03.png)
### Wage Bill and Pressing Intensity

Figure 4 shows the relationship between squad wage bill and season points. The positive correlation (r = 0.834) confirms the widely documented financial determinism of English football: higher-spending clubs finish higher. However, the scatter around the regression line is noticeably wider than for xG and xGA, indicating that financial investment alone does not guarantee on-pitch success. Several clubs in the £100–£180 million range show considerable variation in points, suggesting that tactical execution and player efficiency mediate the relationship between spending and outcomes.


**Figure 4: Squad wage bill (£m) vs. season points.**

![Figure 4: Squad wage bill (£m) vs. season points.](images/figure-04.png)
Figure 5 plots PPDA against season points. As expected, lower PPDA is associated with more points (r = −0.932). Clubs with PPDA values below 9 (such as Manchester City and Liverpool) are concentrated at the top of the standings, while passive teams with PPDA above 15 tend to cluster below 45 points. The relationship is fairly tight in the lower PPDA range but shows more scatter for defensive-minded teams, possibly because some low-block clubs achieve mid-table finishes through organized defending rather than pressing intensity.


**Figure 5: PPDA (pressing intensity) vs. season points.**

![Figure 5: PPDA (pressing intensity) vs. season points.](images/figure-05.png)
### Correlation Structure and Multicollinearity Considerations

Figure 6 presents the full pairwise correlation matrix for all six variables. All five predictors are strongly correlated with season points: xG (r = 0.948), PPDA (r = −0.932), xGA (r = −0.924), possession (r = 0.890), and wage bill (r = 0.834). Of note is the high inter-predictor correlation between xG and possession (r ≈ 0.89) and between PPDA and xGA (r ≈ −0.90), which may introduce multicollinearity in the multiple regression model. These relationships make intuitive sense as teams that press aggressively tend to limit opponents' build-up and concede fewer quality chances, but will require careful evaluation during the modeling phase.


**Figure 6: Pairwise correlation matrix.**

![Figure 6: Pairwise correlation matrix.](images/figure-06.png)
It is clear from the exploratory analysis that all five candidate predictors show a significant correlation with season points in the expected directions. It is evident that the strongest correlations are shown by the variables xG and xGA and are expected to be the dominant predictors in the regression model. Wage bill acts as a structural predictor, representing the financial order within the English Premier League, while PPDA and possession represent tactical measures independent of financial outlays. The symmetry in the distribution of points makes multiple linear regression an appropriate approach for the formal analysis to follow.

4. Statistical Analysis

### 4.1 Linear Model Progression

Four candidate regression models were estimated in sequence, each adding predictors based on the strength of bivariate correlations identified in Section 3. Table 2 summarizes each model's multiple R², adjusted R², and Akaike Information Criterion (AIC). A lower AIC indicates a better balance between model fit and complexity.

**Table 2: Model Progression**

|Model|R²|Adj. R²|AIC|Predictors Added|
|---|---|---|---|---|
|M1|0.8995|0.8984|580.30|xG|
|M2|0.9357|0.9343|542.07|+ xGA|
|M3|0.9397|0.9376|538.28|+ PPDA|
|M4|0.9398|0.9362|542.17|+ Possession, Wage Bill|

Model 1 (xG only) already explains 89.95% of variation in season points (R² = 0.8995), which confirms the dominant role of offensive expected goals in the Premier League table. Adding expected goals against in Model 2 raises R² to 0.9357 and drops AIC by 38 points — the largest single improvement in the progression. Adding PPDA in Model 3 yields a further modest increase (R² = 0.9397, AIC = 538.28). However, expanding to the five-predictor Model 4 with possession and wage bill reduces adjusted R² slightly (0.9362 vs. 0.9376 in M3) and raises AIC by nearly four points, indicating that these two variables add noise rather than signal. The marginal gain from M3 to M4 is negligible (0.0001), while AIC increases, indicating overfitting. Therefore, Model 3 is selected as the final model.


**Figure 7: Adjusted R² across the four candidate models.**

![Figure 7: Adjusted R² across the four candidate models.](images/figure-07.png)
### 4.2 Final Predictive Model

The final selected model is a multiple linear regression of season points on three predictors:

Points = 70.863 + 0.483(xG) − 0.504(xGA) − 1.254(PPDA)

Table 3 presents the full coefficient estimates, standard errors, t-statistics, and p-values. The model achieves an R² of 0.9397 and an adjusted R² of 0.9376. This means that approximately 93.8% of the variation in season points across the 90 team-season observations is explained by these three predictors. The residual standard error is 4.658 points, indicating that the model's predictions are typically within ±4.7 points of the actual total.

**Table 3: Final Model Coefficients (M3)**

|Predictor|Estimate|Std. Error|t-value|p-value|
|---|---|---|---|---|
|(Intercept)|70.863|11.380|6.227|< 0.001 ***|
|xG|0.483|0.090|5.374|< 0.001 ***|
|xGA|−0.504|0.081|−6.192|< 0.001 ***|
|PPDA|−1.254|0.524|−2.391|0.019 *|

n = 90, df = 86.


**Figure 8: Coefficient estimates with 95% confidence intervals.**

![Figure 8: Coefficient estimates with 95% confidence intervals.](images/figure-08.png)
Intercept (70.863): When all three predictors equal zero, the model predicts 70.86 points. This value is not practically meaningful by itself, as no team generates zero xG or concedes zero xGA, but it serves as a baseline from which the predictor effects are measured.

xG (0.483, p < 0.001): Each additional expected goal scored across a season is associated with an increase of approximately 0.48 points, holding xGA and PPDA constant. A team that generates 10 more expected goals than a comparable opponent over the course of a season would be predicted to earn about 4.8 additional points. This coefficient is statistically significant at the 0.001 level, consistent with the strong bivariate correlation (r = 0.948) observed in the previous sections.

xGA (−0.504, p < 0.001): Each additional expected goal conceded is associated with a decrease of roughly 0.50 points per season, holding other predictors constant. The coefficient magnitude is nearly equal and opposite to that of xG, suggesting that defensive and offensive performance contribute to league points in approximately equal measure.

PPDA (−1.254, p = 0.019): Each unit increase in PPDA, is associated with a loss of 1.25 points per season. Because lower PPDA indicates more aggressive pressing, this negative coefficient confirms that teams which press higher up the pitch tend to accumulate more points. A team with a PPDA of 14 (passive) versus one at 9 (aggressive) would be predicted to earn approximately 6.3 fewer points per season.

### 4.3 Inference Test 1: ANOVA F-Test on the Regression Model

The first formal inference procedure tests whether the overall regression model is statistically significant.

H₀: β₁ = β₂ = β₃ = 0

Hₐ: At least one βᵢ ≠ 0

The ANOVA F-test for Model 3 yields F(3, 86) = 447.0, p < 0.001. This is a rejection of the null hypothesis. The sequential ANOVA table further decomposes the explained variance by predictor: xG alone accounts for 27,857.9 points-squared of variation (F = 1283.7, p < 0.001), xGA adds an incremental 1,121.6 (F = 51.7, p < 0.001), and PPDA contributes an additional 124.1 (F = 5.72, p = 0.019). Together, these three predictors account for 29,103.6 of the total sum of squares, leaving only 1,866.2 unexplained across 86 residual degrees of freedom.

In context, this result means that expected goals scored, expected goals conceded, and pressing intensity together provide a statistically reliable and practically strong explanation of where Premier League clubs finish in the league table. The probability of observing an F-statistic this large by chance alone, if the predictors truly had no effect, is approximately zero.

### 4.4 Inference Test 2: Two-Sample t-Test for Difference in Mean xG

The second inference procedure tests whether Premier League clubs in the upper half of the final standings generate significantly more expected goals than clubs in the lower half. Teams were classified as top-half (≥ 49 points, the sample median) or bottom-half (< 49 points).

H₀: μ_top = μ_bottom

Hₐ: μ_top ≠ μ_bottom

Top-half clubs averaged 64.31 season xG, compared to 40.45 xG for bottom-half clubs — a difference of 23.86 expected goals. A Welch two-sample t-test (which does not assume equal variances) yields t(72.18) = 9.04, p < 0.001, with a 95% confidence interval for the difference in means of (18.60, 29.11) expected goals. The null hypothesis is rejected at any conventional significance level.


**Figure 11: Boxplot of season xG by points tier.**

![Figure 11: Boxplot of season xG by points tier.](images/figure-09.png)
In context, this result means that the xG gap between contending and struggling clubs is not merely a matter of random variation. Top-half clubs create, on average, nearly 24 more high-quality scoring opportunities across a 38-game season. This finding independently corroborates the regression coefficient on xG and reinforces the conclusion that attacking output is a fundamental driver of Premier League standings.

### 4.5 Regression Diagnostics

Four diagnostic checks confirm that the assumptions of ordinary least squares are satisfied for Model 3.


**Figure 9: Residuals vs. Fitted Values.**

![Figure 9: Residuals vs. Fitted Values.](images/figure-10.png)

**Figure 10: Normal Q-Q Plot of Residuals.**

![Figure 10: Normal Q-Q Plot of Residuals.](images/figure-11.png)
Linearity and homoscedasticity: Figure 9 plots residuals against fitted values. The points are randomly scattered around zero with no discernible curvature or fan pattern.

Normality of residuals: Figure 10 (Normal Q-Q plot) shows that residual quantiles track closely along the theoretical normal reference line, with slight deviation only in the tails.

Independence: Because the sample was drawn at random from distinct team-seasons, and no club-season appears more than once in the sample, observations are reasonably independent. Clustering by club across seasons is a potential concern but is mitigated by the random sampling design described in Section 2.

Overall assessment: All four classical OLS assumptions are satisfied. The model is well-specified and its inferential results are valid. The combination of a high adjusted R² (0.9376), significant F-statistic (p < 0.001), individually significant coefficients, and clean diagnostics establishes Model 3 as a reliable and interpretable predictive tool for Premier League season outcomes.

5. Discussion and Interpretation

Clearly, expected goals scored (xG) and expected goals conceded (xGA) are the most important predictor variables. The correlations between the former and the latter with the season points were found to be 0.948 and −0.924, respectively. Every extra point of expected goals scores about 0.9 to 1.0 extra points for a season when all other factors remain constant, while each extra unit of expected goals conceding results in losing a similar number of points. In common sense, this makes perfect sense because if a team has been creating good chances and restricting their opponent from doing the same, then logically they should win. The negative sign of the coefficient for PPDA in our regression shows us that higher PPDA means lower aggression in passing defense, hence fewer points scored by a team. Overall, an ANOVA test for significance gives us a result well below 0.001.

While possession and wage bill can be identified as two factors with a positive impact on points gained, it is much trickier to identify their contribution in isolation as they are correlated with performance indicators as well. A side that plays aggressively, thus creating lots of quality scoring opportunities, is also expected to dominate possession and spend more on wages. The inclusion of xG and xGA in the model reduces the impact of both possession and wage bill as independent predictors. At the same time, wage bill appears to remain a statistically significant variable despite other predictors' inclusion. The correlation with financial aspects seems to persist, reflecting the importance of squad strength and player rotation during the season.

### The Strength of the Predictive Model

An adjusted R-squared near 0.97 is unusually strong for a predictive model in sports. The high R-squared here is partly a reflection of the fact that season totals smooth out the random game-to-game variation that makes single matches hard to predict. Over 38 games, the quality differences between clubs are allowed to express themselves fully, and xG-based metrics capture those quality differences well.

### Implications of the Results

This raises some interesting implications in terms of interpreting success in the Premier League. Firstly, the overwhelming dominance of both xG and xGA over wage bill shows that the actual performance on the pitch is just as, if not more, important than financial strength. While wage bill correlates with points earned (r = 0.834), there is a large spread in this relationship such that a number of medium budget teams can exceed their budgets in some years, while other high-spending teams underachieve relative to their investment levels.

Second, the two-sample t-test comparing xG between top-half and bottom-half teams confirms that the attacking output gap between these two groups is statistically significant (p < 0.001). Teams finishing in the upper half of the table generate substantially more expected goals on average than teams in the lower half.

Third, the results suggest that pressing intensity is a real source of competitive advantage and not just a stylistic preference. Teams with low PPDA values, tend to finish with more points than passive teams that allow opponents to build up freely. This is notable because pressing is largely an optional tactical choice and we see a typical trend where teams that actively adopt this method do significantly better than the ones who chose to low block. That being said, even teams that struggle in the relegation zone and without matching skills as the top teams are now risking by using the pressing system instead of simply sitting back and defend.

### Connection to Previous Research

The conclusions of the analyses presented here corroborate those reached by previous studies on football analytics quite well. The use of xG as an important predictor of team success in sports analytics has been discussed many times before. It is demonstrated that metrics that use expected goals work better than either measures based solely on shots taken or the simple count of goals scored.

Pressing as an indicator of match outcome has recently gained much importance as well. This is due to the success of high-pressing strategies implemented by football teams managed by people such as Jürgen Klopp and Pep Guardiola since 2017–18 up to the recent season 2023–24 analyzed here. Pressing data measured by PPDA have proved to be an important tactical signal, as was discovered from the obtained coefficient of −0.932.

The result obtained in terms of financial determinism also falls under an extensive field of work performed in the field of sports economics. Several studies conducted into the correlation between wages and performance of teams in the European football league system concluded that the amount spent on the wages of players is among the best structural factors determining league positions. This research paper does not challenge that conclusion but demonstrates that on-field measures such as xG and xGA better predict the variance of league positions.

In this respect, the gap left by previous empirical team-level research of the English Premier League includes the combination of both tactical and financial variables.

### Limitations

The data includes only 140 observations over seven seasons, while 90 observations have been randomly sampled in order to model them, leaving behind 50 observations. 90 observations can be considered sufficient for five independent variables, however, if the data included more seasons, then more stable values could be achieved and even validation through cross-validation could be conducted. In addition, past performance does not predict the future, as the game tactics in the Premier League evolve rapidly from season to season.

Multicollinearity is also an important limitation pointed out above. As all four variables, namely xG, possession, PPDA, and xGA, measure related concepts in terms of playing style, it is challenging to estimate the influence of each predictor independently. In the future, it would be better if there were fewer predictors that are less correlated.

6. Conclusion and Future Directions

In this study, it was aimed to find whether tactical and financial factors would help predict Premier League performance in the span of seven years (from 2017-18 to 2023-24). In this regard, it has been found that season points can be successfully predicted by the appropriate combination of different predictors using the sample of 90 observations.

Expected goals scored and conceded were the leading predictors indicating that luck has the greatest impact on overall results of the teams. PPDA verified pressing as an effective strategy while the wage bill kept its predictive power after controlling the actual game outcomes.

The value added by this study is its inclusion of both tactical and financial predictors into one predictive model, which has rarely been done previously by existing literature focusing on EPL team-level analysis over this period of time.

In future research, expanding the data sample for multiple seasons or other leagues could be considered to test the generalizability of findings and increase the stability of coefficients. Using individual player statistics such as xG per minute played or injury reports would clarify the mechanism through which roster depth buffers the wage-performance association. Dimension reduction using methods like PCA would also be useful to overcome multicollinearity issues among xG, xGA, PPDA, and possession statistics.


## Sources

- Capology. Football Salaries & Finances. Capology, www.capology.com.
- Dimopoulos, George Robert, and Esau Veliz. "Here We Go! Predicting Transfer Market Valuations of Premier League Footballers." Stanford CS224W: Machine Learning with Graphs, Medium, 20 Feb. 2025, medium.com/stanford-cs224w/here-we-go-predicting-transfer-market-valuations-of-premier-league-footballers-1774131946ff.
- Greer, Daniel, et al. "OpenFPL: An Open-Source Forecasting Method Rivaling State-of-the-Art Fantasy Premier League Services." arXiv, 29 July 2025, arxiv.org/abs/2508.09992.
- Hall, Stephen, Stefan Szymanski, and Andrew S. Zimbalist. "Testing Causality Between Team Performance and Payroll: The Cases of Major League Baseball and English Soccer." Journal of Sports Economics, vol. 3, no. 2, May 2002, pp. 149–168. DOI: 10.1177/152700250200300204.
- Ijezie, Daniel. Premier League Data from 2016 to 2025. Kaggle, 2024, www.kaggle.com/datasets/danielijezie/premier-league-data-from-2016-to-2024.
- Li, Xinyao. "English Premier League Data Analysis: Insights and Recommendations." Proceedings of the 2024 5th International Conference on Big Data and Social Sciences (ICBDSS 2024), Atlantis Press, 13 Nov. 2024, pp. 37–48. DOI: 10.2991/978-94-6463-562-1_5.
- Sports Reference LLC. FBref: Football Statistics and History. Sports Reference, fbref.com.
- Trainor, Colin. "Defensive Metrics: Measuring the Intensity of a High Press." StatsBomb, 30 July 2014, statsbomb.com/articles/soccer/defensive-metrics-measuring-the-intensity-of-a-high-press.
- Understat.com: xG Stats for Teams and Players from the Top European Leagues. Understat, understat.com.
