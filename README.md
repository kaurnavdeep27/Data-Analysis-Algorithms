# Data-Mining-Algorithms

In kNN I am trying to find if a person has "Benign" or "Malignant" state of cancer by looking at other factors. 
In this, I am preprocessing data, then normalizing it, then found the perfect value of k using elbow method.

Output that i was able to achieve was : 76% accuracy. Following was result table.

                      Cancer_prediction 
CancerData_test_labels |         B |         M | Row Total | 
-----------------------|-----------|-----------|-----------|
                     B |         8 |         7 |        15 | 
                       |     0.533 |     0.467 |     0.500 | 
                       |     1.000 |     0.318 |           | 
                       |     0.267 |     0.233 |           | 
                     M |         0 |        15 |        15 | 
                       |     0.000 |     1.000 |     0.500 | 
                       |     0.000 |     0.682 |           | 
                       |     0.000 |     0.500 |           | 
          Column Total |         8 |        22 |        30 | 
                       |     0.267 |     0.733 |           | 
-----------------------|-----------|-----------|-----------|
