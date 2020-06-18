Sys.setlocale("LC_ALL","Russian")
library(dplyr)
library(hydroGOF)

# исходные данные
load('test_df.RData')

# варианты 
# var1 - подбор a и b, формула a * exp(b * mean_temp)
# var2 - a и b из var1, формула a * exp(b * mean_temp - 0.1 * prec)
# var3 - a и b из var1, подбор с, формула a * exp(b * mean_temp - c * prec)
# var4 - формула 2.0 * exp(0.08 * mean_temp - 0.1 * prec)
# var5 - подбор a, b и с, формула a * exp(b * mean_temp - c * prec)
# var6 - подбор a, формула a * exp(0.08 * mean_temp - 0.1 * prec)

# var1
mod_var1 <- test_df %>%
  dplyr::filter(cond == 'dry') %>%
  dplyr::group_by(index) %>%
  dplyr::do(mod = nls(formula = def ~ a * exp(b * mean_temp), 
                      start = list(a=1000, b=0),
                      control = nls.control(maxiter = 1000, minFactor = 0.0003, printEval = T, warnOnly = T),
                      trace=T, data = .)) %>%
  dplyr::mutate(a.var1 = coef(mod)[[1]],
                b.var1 = coef(mod)[[2]])

coefs <- mod_var1[,c(1,3,4)]

test_df <- test_df %>%
  dplyr::left_join(mod_var1, by = 'index') %>%
  dplyr::group_by(index) %>%
  dplyr::mutate(pred_var1 = a.var1 * exp(b.var1 * mean_temp)) %>%
  dplyr::select(index, date, mean_temp, prec, def, cond, pred_var1)

summary(test_df)

# var2
test_df <- test_df %>%
  dplyr::left_join(mod_var1, by = 'index') %>%
  dplyr::group_by(index) %>%
  dplyr::mutate(pred_var2 = a.var1 * exp(b.var1 * mean_temp - 0.1 * prec)) %>%
  dplyr::select(index, date, mean_temp, prec, def, cond, pred_var1, pred_var2)

summary(test_df)

# var3
mod_var3 <- test_df %>%
  dplyr::left_join(mod_var1[,c(1, 3, 4)], by='index') %>%
  dplyr::group_by(index) %>%
  dplyr::do(mod = nls(formula = def ~ a.var1 * exp(b.var1 * mean_temp - c * prec),
                      start = list(c=0),
                      control = nls.control(maxiter = 1000, minFactor = 0.0003, printEval = T, warnOnly = T),
                      trace=T, data = .)) %>%
  dplyr::mutate(c.var3 = coef(mod)[[1]])

coefs <- merge(coefs, mod_var3[,c(1, 3)], by='index')

test_df <- test_df %>%
  dplyr::left_join(mod_var3[,c(1,3)], by = 'index') %>%
  dplyr::left_join(mod_var1[,c(1,3,4)], by = 'index') %>%
  dplyr::group_by(index) %>%
  dplyr::mutate(pred_var3 = a.var1 * exp(b.var1 * mean_temp - c.var3 * prec)) %>%
  dplyr::select(index, date, mean_temp, prec, def, cond, pred_var1, pred_var2, pred_var3)

# var4
test_df <- test_df %>%
  dplyr::group_by(index) %>%
  dplyr::mutate(pred_var4 = 2.0 * exp(0.08 * mean_temp - 0.1 * prec)) %>%
  dplyr::select(index, date, mean_temp, prec, def, cond, 
                pred_var1, pred_var2, pred_var3, pred_var4)

# var5
mod_var5 <- test_df %>%
  dplyr::group_by(index) %>%
  dplyr::do(mod = nls(formula = def ~ a * exp(b * mean_temp - c * prec), 
                      start = list(a=1000, b=0, c=0),
                      control = nls.control(maxiter = 1000, minFactor = 0.0003, printEval = T, warnOnly = T),
                      trace=T, data = .)) %>%
  dplyr::mutate(a.var5 = coef(mod)[[1]],
                b.var5 = coef(mod)[[2]],
                c.var5 = coef(mod)[[3]])

coefs <- merge(coefs, mod_var5[,c(1, 3, 4, 5)], by = 'index')

test_df <- test_df %>%
  dplyr::left_join(mod_var5[,c(1, 3, 4, 5)], by = 'index') %>%
  dplyr::group_by(index) %>%
  dplyr::mutate(pred_var5 = a.var5 * exp(b.var5 * mean_temp - c.var5 * prec)) %>%
  dplyr::select(index, date, mean_temp, prec, def, cond, pred_var1, pred_var2, 
                pred_var3, pred_var4, pred_var5)
summary(test_df)


# var6
mod_var6 <- test_df %>%
  dplyr::group_by(index) %>%
  dplyr::do(mod = nls(formula = def ~ a * exp(0.08 * mean_temp - 0.1 * prec),
                      start = list(a=1000),
                      control = nls.control(maxiter = 1000, minFactor = 0.0003, printEval = T, warnOnly = T),
                      trace=T, data = .)) %>%
  dplyr::mutate(a.var6 = coef(mod)[[1]])

coefs <- merge(coefs, mod_var6[,c(1, 3)], by = 'index')

# save(coefs, file = 'coefs.RData')

test_df <- test_df %>%
  dplyr::left_join(mod_var6[,c(1,3)], by = 'index') %>%
  dplyr::group_by(index) %>%
  dplyr::mutate(pred_var6 = a.var6 * exp(0.08 * mean_temp - 0.1 * prec)) %>%
  dplyr::select(index, date, mean_temp, prec, def, cond, pred_var1, pred_var2, 
                pred_var3, pred_var4, pred_var5, pred_var6)

save(test_df, file = 'mod1-6.RData')

# оценки
r2 <- test_df %>%
  dplyr::group_by(index) %>%
  dplyr::summarise(r2_var1 = cor(def, pred_var1),
                   rmse_var1 = rmse(pred_var1, def),
                   r2_var2 = cor(def, pred_var2),
                   rmse_var2 = rmse(pred_var2, def),
                   r2_var3 = cor(def, pred_var3),
                   rmse_var3 = rmse(pred_var3, def),
                   r2_var4 = cor(def, pred_var4),
                   rmse_var4 = rmse(pred_var4, def),
                   r2_var5 = cor(def, pred_var5),
                   rmse_var5 = rmse(pred_var5, def),
                   r2_var6 = cor(def, pred_var6),
                   rmse_var6 = rmse(pred_var6, def))
summary(r2)

# save(r2, file = 'r2_mod1-6.RData')