# Estudio probabilístico de la ruleta europea. Apuesta simple al color.

# Definición de la ruleta. 18 números rojos, 18 números negros y 1 número verde (0).
ruleta = c('V', rep(c('R','N'),18))

# Probabilidades teóricas
## Regla de LaPlace
prob_rojo = length(ruleta[ruleta=='R']) / length(ruleta); prob_rojo
prob_negro = length(ruleta[ruleta=='N']) / length(ruleta); prob_negro

## Esperanza matemática
## Juguemos al rojo!
prob_exito = prob_rojo
prob_fracaso = 1 - prob_exito # Fracaso = negro o '0'
ganancia = 1; perdida = -1 # 1 € por apuesta
esperanza = prob_exito * ganancia + prob_fracaso * perdida


# Simulación
## A efectos de reproducibilidad, establecemos la semilla manualmente
set.seed(1234)

## Simulación de 'n' tiradas
tirar = function(n=1){
    # Realiza un número 'n' de tiradas, por defecto 1.
    return(sample(ruleta, n, replace=TRUE))
}

tiradas = tirar(5000)
table(tiradas)

barplot(table(tiradas), color=c('black','red','green')

apostar = function(n=1, c='R', prison=F){
    # Realiza un número 'n' de apuestas a un color. La prision controla el efecto que tiene el verde sobre el resultado de la apuesta.
    # Devuelve la cantidad ganada.
    tirada = tirar(n)
    aciertos = sum(tirada == c)
    if (prison)
        fallos = sum((tirada != c) & (tirada != 'V'))
    else
        fallos = sum(tirada != c)
    return(aciertos - fallos)
}

#apuestas = apostar(100)
tandas = replicate(2500, apostar(100))

plot(tandas[1:250], col=ifelse(tandas < 0, 'red', 'green'), pch=16)
grid()
abline(h=0)

esperanza_simulada = mean(tandas)


