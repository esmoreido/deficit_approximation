Sys.setlocale("LC_ALL","Russian")
library(ggplot2)
library(reshape2)
library(dplyr)
library(ggsci)
# рабочая директория
setwd('d:/ИВПРАН/deficit')

load('mod1-6.RData') # расчеты
load('r2_mod1-6.RData') # оценки

mr2 <- melt(r2, id.vars = 'index')
mr2$var <- substr(mr2$variable, regexpr("_", mr2$variable)+1, length(mr2$variable))
mr2$coef <- substr(mr2$variable, 1, regexpr("_", mr2$variable) - 1)



p1 <- ggplot(mr2, aes(y=var, x=value, fill=var)) + 
  geom_boxplot() + facet_wrap(coef~., scales = 'free', 
                              labeller = as_labeller(c('r2'='R', 'rmse'='СКО, мБар'))) +
  theme_light(base_size=16) + labs(y='№ эксперимента', x='Значение', fill='Модель') +
  scale_y_discrete(labels=as.character(1:6)) +
  scale_fill_npg(labels=as.character(1:6))
p1

ggsave(plot = p1, filename = "r2_rmse_boxplot.png", width = 12, height = 5, dpi = 150, device = 'png')

p2 <- mr2 %>%
  dplyr::group_by(var, coef) %>%
  dplyr::summarise(av = mean(value)) %>%
  ggplot(., aes(x=var, y=av, fill=var)) + geom_bar(stat = 'identity', position = 'dodge') + 
  facet_grid(coef~., scales='free', labeller = as_labeller(c('r2'='R', 'rmse'='СКО, мБар'))) + 
  geom_text(aes(label=round(av, 3)), nudge_y = -0.1, show.legend = F, col='White') +
  labs(x='№ эксперимента', y='Значение', fill='') + 
  scale_x_discrete(labels=as.character(1:6)) +
  theme(legend.position = 'NA') + scale_fill_npg() + theme_light(base_size = 16) +
  theme(legend.position = 'NA')
p2
ggsave(plot = p2, filename = "r2_rmse_bar.png", width = 12, height = 5, dpi = 150, device = 'png')

# самая важная картинка
p3 <- mr2 %>%
  dplyr::group_by(var, coef) %>%
  dplyr::summarise(av = mean(value)) %>%
  dcast(., var~coef, value.var = 'av') %>%
  ggplot(., aes(x=r2, y=rmse, col=var)) + geom_point(size=6) +
  xlim(0.83, 0.9) + ylim(1.45, 1.9) + 
  geom_text(label=1:6, nudge_x = 0.002, nudge_y = 0.01, show.legend = F, size=6) +
  theme_light(base_size = 16) + labs(x='R', y='СКО, мБар', col='Модель') + 
  scale_color_npg(labels = 1:6)
p3
ggsave(plot = p3, filename = "r-rmse-plot.png", width = 9, height = 5, dpi = 150, device = 'png')

p4 <- ggplot(mr2, aes(x=value, fill=var)) + 
  geom_histogram(bins=50) + 
  facet_grid(var~coef, scales = 'free', 
                              labeller = as_labeller(c(c('r2'='R', 'rmse'='СКО, мБар'), 
                                                     c('var1'='1','var2'='2','var3'='3','var4'='4','var5'='5','var6'='6')))) +
  theme_light(base_size=16) + labs(y='Число станций', x='Значение', fill='Модель') +
  scale_fill_npg(labels=as.character(1:6))
p4
ggsave(plot = p4, filename = "r-rmse-histogram.png", width = 9, height = 5, dpi = 150, device = 'png')


test_st <- sample(unique(df$index), 16, replace = F)
test_st
test_df <- df[df$index %in% test_st,]
save(test_df, file = 'test_df.RData')
str(test_df)
p5 <- test_df %>%
  dplyr::group_by(index) %>%
  ggplot(aes(x=mean_temp, y=def, col=index)) + geom_point() +
       geom_smooth(method = 'nls', se = F, col='Blue', 
                   formula = y ~ a * exp(0.08 * x),
                   method.args = list(start=c(a=1000),
                       control = nls.control(maxiter = 1000, minFactor = 0.0003, printEval = T, warnOnly = T),
                       trace=T)) +
       geom_abline() + xlim(0, 40) + ylim(0, 40) + facet_wrap(index~.) +
       labs(x='Температура, °С', y='Дефицит влажности, мБар', col='Индекс м/с') +
  theme_light(base_size = 20)
p5
ggsave(plot = p5, filename = "test_approx.png", width = 9, height = 9, dpi = 150, device = 'png')
