# Estudio probabilístico de la ruleta europea. Apuesta simple al color.

# Definición de la ruleta. 18 números rojos, 18 números negros y 1 número verde (0).
ruleta = c('V', rep(c('R','N'),18))
colores = c('V',rep(c('R','N'),5), rep(c('N','R'),4), rep(c('R','N'),5), rep(c('N','R'),4))
docenas = c(0, rep(1,12), rep(2,12), rep(3,12))


# Probabilidades teóricas
## Regla de LaPlace
prob_rojo = sum(ruleta=='R') / length(ruleta); prob_rojo
prob_negro = sum(ruleta=='N') / length(ruleta); prob_negro

## Esperanza matemática
## Juguemos al rojo!
prob_exito = prob_rojo
prob_fracaso = 1 - prob_exito # Fracaso = negro o 0
ganancia = 1; perdida = -1 # 1 € por apuesta
esperanza = prob_exito * ganancia + prob_fracaso * perdida; esperanza


# Simulación
## A efectos de reproducibilidad, establecemos la semilla manualmente
set.seed(12345)

## Simulación de 'n' tiradas
tirar = function(n=1){
    # Realiza un número 'n' de tiradas, por defecto 1.
    return(sample(ruleta, n, replace=TRUE))
}

tiradas = tirar(5000)
table(tiradas)

dev.new()
barplot(table(tiradas), col=c('black','red','green'), main="Conteo de colores en 5000 tiradas a color.")

# Simulación de 'n' apuestas a color
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

# Realizamos 2500 simulaciones de 100 tiradas cada una
tandas = replicate(5000, apostar(100))

dev.new()
plot(tandas[1:250], col=ifelse(tandas < 0, 'red', 'green'), pch=16, main="Apuestas ganadoras vs perdedoras", xlab="Apuesta", ylab="Resultado")
grid()
abline(h=0)


# La esperanza simulada la calculamos como la media de todas las simulaciones
esperanza_simulada = mean(tandas); esperanza_simulada

