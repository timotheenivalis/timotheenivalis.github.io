---
layout: post
title: Models of selection and evolution with a more realistic fitness distribution
excerpt: "Logarithms are miraculous"
date: 2019-07-02T10:00:02+9:00
modified: 2019-07-13T18:08:02+9:00
tags: [Timothée Bonnet, research, project, fitness, animal model, GLMM, Poisson, evolution, selection]
categories: [science]
comments: true
image:
  feature: nails.JPG
  credit: Timothee Bonnet
  creditlink: http://timotheenivalis.github.io
---

We have just published two papers that are quite special to me. They may seem quite arcane, but I am very excited about them as they end 7 years of personal struggle and I know many researchers have faced the same issues for decades.

## Theorems of evolution for log-normal fitness

The first one, *Analogues of the fundamental and secondary theorems of selection, assuming a log-normal distribution of expected fitness* [https://doi.org/10.1093/jhered/esz020](https://doi.org/10.1093/jhered/esz020) is mostly Michael Morrissey's work. I contributed only a tiny result (eq. 8-9) discovered by accident (yes, I accidentaly wrote an equation; then saw what it meant, and only last found out the equation was correct). In very brief, it demonstrates the first and the second theorems of natural selection in the case where fitness is log-normal. The first theorem is Fisher's fundamental theorem of natural selection, which says that the rate of adaptive evolution in a population is the additive genetic variance in relative fitness, and the second theorem is the Robertson-Price identity, which can measure selection on a trait or the rate of evolution in that trait. The log-normal thing can seem a bit random, but it is super useful to have this result because many empirical models of selection/evolution rely on Poisson or negative-binomial Generalized Linear Mixed Models, which assume that log-normal distribution for fitness. This assumption is generally violated a bit, or lot, but at least now we know what our empirical estimates mean in evolutionary terms under the assumption.

## Estimation of evolution

The second paper, *Estimation of Genetic Variance in Fitness, and Inference of Adaptation, When Fitness Follows a Log-Normal Distribution* [https://doi.org/10.1093/jhered/esz018](https://doi.org/10.1093/jhered/esz018) is very related to the first one, but focuses on the empirical application of the theory developed in the first one (funny enough, I drafted the second paper before reading the first one; of course that draft was very wrong!). This is the one paper I wish I could have read when I started my PhD in 2012, because it clarifies the meaning of parameters estimated in Poisson (or negative-binomial) quantitative genetic models of fitness. Fitness is everywhere in evolutionary studies: selection, rate of evolution, pop dynamics... but it's difficult to model because it generally follows non-Gaussian distributions. When I started my PhD I read and was taught: estimate parameters with Gaussian models, test significance with GLMMs (for instance Poisson). We didn't know how to interpret parameters from Poisson models (which often fit fitness data okay) in evolutionary terms (e.g., additive genetic variance); you would look at p-values and then estimate the parameter in a Gaussian model. That was so confusing to me!

There were hints that Poisson parameters were meaningful: some papers said without explicit demonstration that they were directly interpretable as parameters in Lande models; and we knew it was in principle possible to back-transform Poisson parameters to the data scale. However, I could not find explicit demonstrations or explanations and no one could tell me exactly how to scale/transform them in order to interpret them in evolutionary terms. In particular it was not clear whether Poisson parameters were about absolute or relative fitness, as you fit them to absolute fitness data but want relative fitness parameters.

It turns out, and I think that is the most important take home message, parameters from Poisson models are exactly what you want, without need for any scaling or back-transformation! Fit a Poisson model to absolute fitness data, and directly get Fisher's rate of evolution (immediately on the scale of data for relative fitness) or selection gradients.

However, you can back-transform Poisson models, and get some unexpected insights: the back-transformed parameters to the data scale captures the inheritance distortion inherent to exponential scales. This distortion originates from the mapping of additive genetic effect onto non-additive effects when you go from the log-normal scale to the data scale. The distortion speeds up the increase in fitness beyond Fisher's fundamental theorem. Probably we should not have, but we coined this pattern "environmental amelioration" by analogy with "environmental deterioration"; note that in both cases the "environment" is in part genetic and does not correspond to the usual meaning of environment. So the direct Poisson estimate of additive genetic variance in fitness gives you the **increase in fitness within a generation**, directly, without transformation; while the back-transformed estimate gives the **increase between generations** which is the sum of adaptation and inheritance distortion.

All of that assumes log-normality of fitness, which is sometimes not too far from true, but also often violated. They can be super insightful but don't trust the Poisson model blindly (zero-inflated models could be more robust, but more on that later!).

## Standing on giants shoulders

This work was possible only with Michael Morrissey's incredibly deep knowledge of evolutionary theory and math agility; and with Loeske Kruuk's academic rigour, who forced me to refine and clarify my ideas until they truly made sense (which was a long process!). I would not have written anything on the topic without Michael and Loeske. However, I was very motivated to solve these issues and write about them because the question of what to do with empirical models of fitness had been bothering me since the beginning of my PhD. The interest was kept alive and solutions started to emerge thanks to great discussions with my PhD supervisor Erik Postma, but also Pierre de Villemereuil, François Rousset, and Simon Evans.


<section id="table-of-contents" class="toc">
  <header>
    <h3>Sections</h3>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->
