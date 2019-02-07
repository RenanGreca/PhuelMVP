// Constants
var len = 48
        
var colora = "#d70206"
var colorb = "#f05b4f"
var colorc = "#f4c63d"
var colord = "#d17905"
var colore = "#aac905"
var colorf = "#aac9e5"

var phuelBlue = "#38424E"
var phuelOrange = "#F05022"

var descriptions = [
"Este cenário mostra o consumo já existente dentro da Unidade Consumidora (UC) CDD Mooca, bem como a capacidade de seu transformador de distribuição.",
"Mostra o contraste entre o consumo já existente dentro da Unidade Consumidora (UC) CDD Mooca e a capacidade de geração de energia por Painéis Fotovoltaicos, operando dentro dos limites da capacidade do seu transformador de distribuição.",
"Exibe o pico de consumo de energia ocasionado por veículos elétricos chegando na Unidade Consumidora, quando estes são conectados para a recarga. Nesta situação o transformador de distribuição opera em sobrecarga, o que pode causar danos e perda de vida útil.",
"Ilustra o benefício maior da solução Phuel, que é o agendamento e automatização das recargas de veículos elétricos. Nesta situação, os veículos são conectados ao mesmo tempo, porém o período de suas recargas é gerenciado, de forma a reduzir o impacto imediato na instalação e obter melhores preços nas recargas.",
"Contrasta a necessidade energética dos veículos, bem maior que o consumo interno na Unidade Consumidora (isto é, o consumo não relacionado a veículos elétricos) com a geração solar, notando também que os horários não são coincidentes."
]

// Variables
var currentScenario = 1

// Time of day in 30 min interval
var hours = ['0','','1','','2','','3','','4','','5','',
'6','','7','','8','','9','','10','','11','',
'12','','13','','14','','15','','16','','17','',
'18','','19','','20','','21','','22','','23','']
// Percentage of transformer load at given times
var arrPercentage = [0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0.3,0.4,0.45,0.6,0.8,0.9,1,1,1,
1,1,1,1,1,1,1,1,0.8,0.7,0.5,0.4,
0.4,0.3,0.2,0.1,0,0,0,0,0,0,0,0,0]
var arrPercentage2 = [0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0.5,0.6,0.6,0.7,0.8,0.9,1,0.9,0.8,
1,0.9,0.7,0.6,0.6,0.5,0.4,0.3,0.3,0.2,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0]
// Percentage of solar panel production at given times
var arrSolar = [0,0,0,0,0,0,0,0,0,0,0,0,
0.1,0.11,0.13,0.18,0.25,0.27,0.29,0.4,0.5,0.61,0.78,0.85,
0.95,1,1,0.98,0.9,0.82,0.74,0.65,0.44,0.35,0.24,0.21,
0.12,0.10,0.05,0.028,0,0,0,0,0,0,0,0]
// Energy requirements for 5 charging vehicles
var arrVehicles = [2.1,1.7,1.1,0.2,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,
0,4.5,5,5,4.75,4.7,4.31,4,3.87,3.76,3.71,3.2]
// Energy requirements
var arrControlledCharge = [8,8,7.5,6.5,6,5.6,5.8,6,6.5,6.8,6.5,7,
6.5,6,5.4,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,2.3,2.8,3.5,5.9,7,7.2,7.5]
var staticPrice = [0.49];
var dynamicPrice = [0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,
0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,
0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.54,0.54,
0.82,0.82,0.82,0.82,0.82,0.82,0.54,0.54,0.42,0.42,0.42,0.42]

// (input)
var transformerCapacity = 45 // kVA
// (input)
var UC1 = 10 // kW
// (input)
var UC2 = 5 // kW
// (input)
var maxSolar = 35 // kW
// (input)
var noVehicles = 5
// (input)
var chargerPower = 25 // kW

// Build the data arrays
var seriesTransformer = Array(len).fill(transformerCapacity*0.92)
var seriesUC1 = arrPercentage.map(val => val * UC1)
var seriesUC2 = arrPercentage2.map(val => val * UC2)
var seriesVehicles = arrVehicles.map(val => chargerPower * val * noVehicles/5);
var seriesVehiclesControlled = arrControlledCharge.map(val => chargerPower * val * noVehicles/15);
var seriesTotal = seriesUC1.map((val, idx) => val + seriesUC2[idx])
var seriesSolar = arrSolar.map(val => (val * maxSolar))
var seriesSolarExcess = seriesSolar.map((val, idx) => val - seriesTotal[idx])

var ctx = document.getElementById('myChart').getContext('2d');
var chart = new Chart(ctx, {
    // The type of chart we want to create
    type: 'line',
    
    // The data for our dataset
    data: {
        labels: hours,
        datasets: []
    },
    
    // Configuration options go here
    options: {
        aspectRatio: 1,
        scales: {
            yAxes: [{
                scaleLabel: {
                    display: true,
                    labelString: "Potência (kW)"
                }
            }],
            xAxes: [{
                scaleLabel: {
                    display: true,
                    labelString: "Horário do dia"
                }
            }]
        },
        legend: {
            position: 'bottom',
            labels: {
                fontColor: '#38424E'
            }
        }
    }
});
switchScenario(1);

function updateCapacity(value) {        
    seriesTransformer = Array(len).fill(value)
    
    switchScenario(currentScenario)
}

function updateTotal(value) {
    seriesUC1 = arrPercentage.map(val => val * value*2/3)
    seriesUC2 = arrPercentage2.map(val => val * value*1/3)
    seriesTotal = seriesUC1.map((val, idx) => val + seriesUC2[idx])
    
    chart.data.datasets[1].data = seriesTotal
    // chart.data.datasets[3].data = seriesTotal
    
    switchScenario(currentScenario)
}

function updateMaxSolar(value) {
    seriesSolar = arrSolar.map(val => (val * value))
    seriesSolarExcess = seriesSolar.map((val, idx) => val - seriesTotal[idx])
    
    switchScenario(currentScenario)
}

function updateVehicleNumber(value) {
    noVehicles = value
    
    seriesVehicles = arrVehicles.map(val => chargerPower * val * value/5);
    seriesVehiclesControlled = arrControlledCharge.map(val => chargerPower * val * value/15);
    
    switchScenario(currentScenario)
}

function switchScenario(number) {
    
    var datasets = []
    switch (number) {
        case 1:
        datasets = [{
            label: "Capacidade do transformador",
            backgroundColor: colora,
            borderColor: colora,
            data: seriesTransformer,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Consumo UC",
            backgroundColor: colord,
            borderColor: colord,
            data: seriesTotal,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        }]
        break
        case 2:
        datasets = [
        {
            label: "Capacidade do transformador",
            backgroundColor: colora,
            borderColor: colora,
            data: seriesTransformer,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Consumo UC",
            backgroundColor: colord,
            borderColor: colord,
            data: seriesTotal,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Geração solar",
            backgroundColor: colorc,
            borderColor: colorc,
            data: seriesSolar,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Excedente de geração solar",
            backgroundColor: colorf,
            borderColor: colorf,
            data: seriesSolarExcess,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        }]
        break
        case 3:
        datasets = [{
            label: "Capacidade do transformador",
            backgroundColor: colora,
            borderColor: colora,
            data: seriesTransformer,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Consumo UC",
            backgroundColor: colord,
            borderColor: colord,
            data: seriesTotal,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Geração solar",
            backgroundColor: colorc,
            borderColor: colorc,
            data: seriesSolar,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Consumo de veículos em recarga",
            backgroundColor: colorf,
            borderColor: colorf,
            data: seriesVehicles,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        }]
        break
        case 4:
        datasets = [{
            label: "Capacidade do transformador",
            backgroundColor: colora,
            borderColor: colora,
            data: seriesTransformer,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Consumo UC",
            backgroundColor: colord,
            borderColor: colord,
            data: seriesTotal,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Geração solar",
            backgroundColor: colorc,
            borderColor: colorc,
            data: seriesSolar,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Consumo de veículos em recarga",
            backgroundColor: colorf,
            borderColor: colorf,
            data: seriesVehicles,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        },{
            label: "Consumo de veículos em recarga inteligente Phuel",
            backgroundColor: colore,
            borderColor: colore,
            data: seriesVehiclesControlled,
            fill: false,
            pointRadius: 0,
            lineTension: 0.2,
        }]
        break
    }
    
    currentScenario = number
    
    chart.data.datasets = datasets
    chart.update()
    
    $("#descricao").html(descriptions[number-1])
    
    var totalCost = (seriesTotal.reduce((acc, val) => acc + val)*staticPrice).toFixed(2);
    $("#custototal").html(totalCost)
    
    if (number == 3 || number == 4) {
        $("#rowcustosimples").css('display', 'table-row')
        $("#rowcustodinamico").css('display', 'table-row')
        $("#rowcustosimplesphuel").css('display', 'table-row')
        $("#rowcustodinamicophuel").css('display', 'table-row')
        
        var staticCost = (seriesVehicles.reduce((acc, val) => acc + val)*staticPrice/noVehicles).toFixed(2);
        $("#custosimples").html(staticCost)
        
        var dynamicCost = (seriesVehicles.map((val, idx) => val * dynamicPrice[idx]).reduce((acc, val) => acc + val)/noVehicles).toFixed(2);
        $("#custodinamico").html(dynamicCost)
        
        var staticCostPhuel = (seriesVehiclesControlled.reduce((acc, val) => acc + val)*staticPrice/noVehicles).toFixed(2);
        $("#custosimplesphuel").html(staticCostPhuel)
        
        var dynamicCostPhuel = (seriesVehiclesControlled.map((val, idx) => val * dynamicPrice[idx]).reduce((acc, val) => acc + val)/noVehicles).toFixed(2);
        $("#custodinamicophuel").html(dynamicCostPhuel)
    } else {
        $("#rowcustosimples").css('display', 'none')
        $("#rowcustodinamico").css('display', 'none')
        $("#rowcustosimplesphuel").css('display', 'none')
        $("#rowcustodinamicophuel").css('display', 'none')
    }
    
    for (var i=1; i<=4; i++) {
        $("#btnCenario"+i).removeAttr('disabled')    
    }
    $("#btnCenario"+number).attr("disabled", "true")
}