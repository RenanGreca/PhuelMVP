   
var vehicle = {
    modelId: 0,
    make: "",
    model: "",
    battery: 0,
    licensePlate: ""
}

var station = {
    modelId: 0,
    make: "",
    model: "",
    power: 0.0,
    current: "",
    specifications: ""
}

function updateModel(modelId) {
    $(".select-battery").css('display', 'none');
    if (modelId) {
        var model = vehicleModels[modelId-1]

        $("#form-battery").css('display', 'block');
        $("#select-battery-"+model.id).css('display', 'block');

        vehicle.modelId = model.id
        vehicle.make = model.make
        vehicle.model = model.model
        vehicle.battery = model.battery[0]

        $("#modelId").val(model.id)
        $("#make").val(model.make)
        $("#model").val(model.model)
        $("#battery").val(model.battery[0])
    } else {
        $("#form-battery").css('display', 'none');
        // $("#select-battery-"+modelId).css('display', 'none');

        vehicle.modelId = 0
        vehicle.make = ""
        vehicle.model = ""
        vehicle.battery = 0
        
        $("#modelId").val(0)
        $("#make").val("")
        $("#model").val("")
        $("#battery").val("")
    }
}

function updateStationModel(modelId) {
    // $(".select-battery").css('display', 'none');
    if (modelId) {
        var model = stationModels[modelId-1]

        // $("#form-battery").css('display', 'block');
        // $("#select-battery-"+model.id).css('display', 'block');

        station.modelId = model.id
        station.make = model.make
        station.model = model.model
        station.power = model.power
        station.specifications = model.extras

    } else {
        // $("#form-battery").css('display', 'none');
        // $("#select-battery-"+modelId).css('display', 'none');

        station.modelId = 0
        station.make = ""
        station.model = ""
        station.power = model.power
        station.specifications = model.extras
        
    }
}

function updateModel(modelId) {
    $(".select-battery").css('display', 'none');
    if (modelId) {
        var model = vehicleModels[modelId-1]

        $("#form-battery").css('display', 'block');
        $("#select-battery-"+model.id).css('display', 'block');

        vehicle.modelId = model.id
        vehicle.make = model.make
        vehicle.model = model.model
        vehicle.battery = model.battery[0]

        $("#modelId").val(model.id)
        $("#make").val(model.make)
        $("#model").val(model.model)
        $("#battery").val(model.battery[0])
    } else {
        $("#form-battery").css('display', 'none');
        // $("#select-battery-"+modelId).css('display', 'none');

        vehicle.modelId = 0
        vehicle.make = ""
        vehicle.model = ""
        vehicle.battery = 0
        
        $("#modelId").val(0)
        $("#make").val("")
        $("#model").val("")
        $("#battery").val("")
    }
}

function updateBattery(batteryValue) {
    vehicle.battery = batteryValue
    $("#battery").val(batteryValue)
}

function updateLicense(licensePlate) {
    vehicle.licensePlate = licensePlate
}


$( "#vehicleForm" ).submit(function( event ) {
    // Stop form from submitting normally
    event.preventDefault();
   
    var form = $( this )
    var url = form.attr( "action" );
   
    // Send the data using post
    var posting = $.post( url, vehicle);
   
    // Put the results in a div
    posting.done(function( data ) {
        if (data.make) {
            $( "#result" ).empty().append( "Veículo "+data.make+" "+data.model+" adicionado com sucesso." );
            $( "#result" ).removeClass("text-danger")
            $( "#result" ).addClass("text-success")
            $( "#result" ).css("display", "block")
        }

        if (data.error) {
            $( "#result" ).empty().append( "Erro ao cadastrar veículo." );
            $( "#result" ).removeClass("text-success")
            $( "#result" ).addClass("text-danger")
            $( "#result" ).css("display", "block")
        }
    });

    posting.fail(function( ) {
        $( "#result" ).empty().append( "Erro ao cadastrar veículo." );
        $( "#result" ).removeClass("text-success")
        $( "#result" ).addClass("text-danger")
        $( "#result" ).css("display", "block")
    });
});

$( "#stationsForm" ).submit(function( event ) {
    // Stop form from submitting normally
    event.preventDefault();
   
    // Get some values from elements on the page:

    var form = $( this )
    var url = form.attr( "action" );

    // var txt = $("#inputPower").val();
    // var power = txt.match(/\d/g);
    // power = power.join("");

    // var station = {
    //     make: "",
    //     model: "",
    //     power: 0.0,
    //     specifications: ""
    // }

    station.current = $('input[name=current]:checked').val()

    // var station = {
    //     model: $("#inputModel").val(),
    //     current: $('input[name=current]:checked').val(),
    //     power: power,
    //     specifications: $("#inputSpecifications").val()
    // }
   
    console.log(station)
    // Send the data using post
    var posting = $.post( url, station );
   
    // Put the results in a div
    posting.done(function( data ) {
        if (data.model) {
            $( "#result" ).empty().append( "Estação "+data.model+" adicionada com sucesso." );
            $( "#result" ).removeClass("text-danger")
            $( "#result" ).addClass("text-success")
            $( "#result" ).css("display", "block")
        }

        if (data.error) {
            $( "#result" ).empty().append( "Erro ao cadastrar estação." );
            $( "#result" ).removeClass("text-success")
            $( "#result" ).addClass("text-danger")
            $( "#result" ).css("display", "block")
        }
    });

    posting.fail(function( ) {
        $( "#result" ).empty().append( "Erro ao cadastrar estação." );
        $( "#result" ).removeClass("text-success")
        $( "#result" ).addClass("text-danger")
        $( "#result" ).css("display", "block")
    });
});

$( "#ucForm" ).submit(function( event ) {
    event.preventDefault();

    var form = $( this )
    var url = form.attr( "action" );

    var consumerUnit = {
        name: $("#inputName").val(),
        region: $("#inputRegion").val(),
        user: $("#inputUser").val(),
        power: $("#inputPower").val(),
        generation: $("#inputGeneration").val(),
        capacity: $("#inputCapacity").val()
    }

    console.log(consumerUnit)
    var posting = $.post( url, consumerUnit );
    // Put the results in a div
    posting.done(function( data ) {
        if (data.name) {
            $( "#result" ).empty().append( "Sucesso ao cadastrar unidade consumidora "+data.name+"." );
            $( "#result" ).removeClass("text-danger")
            $( "#result" ).addClass("text-success")
            $( "#result" ).css("display", "block")
        }

        if (data.error) {
            $( "#result" ).empty().append( "Erro ao cadastrar unidade consumidora." );
            $( "#result" ).removeClass("text-success")
            $( "#result" ).addClass("text-danger")
            $( "#result" ).css("display", "block")
        }
    });

    posting.fail(function( ) {
        $( "#result" ).empty().append( "Erro ao cadastrar unidade consumidora." );
        $( "#result" ).removeClass("text-success")
        $( "#result" ).addClass("text-danger")
        $( "#result" ).css("display", "block")
    });

})

$( "#userForm" ).submit(function( event ) {
    event.preventDefault();

    var form = $( this )
    var url = form.attr( "action" );

    var user = {
        name: $("#inputName").val(),
        email: $("#inputEmail").val(),
        password: $("#inputPassword").val()
    }

    var posting = $.post( url, user );
    // Put the results in a div
    posting.done(function( data ) {
        if (data.name) {
            $( "#result" ).empty().append( "Sucesso ao cadastrar usuário "+data.name+"." );
            $( "#result" ).removeClass("text-danger")
            $( "#result" ).addClass("text-success")
            $( "#result" ).css("display", "block")
        }

        if (data.error) {
            $( "#result" ).empty().append( "Erro ao cadastrar unidade consumidora." );
            $( "#result" ).removeClass("text-success")
            $( "#result" ).addClass("text-danger")
            $( "#result" ).css("display", "block")
        }
    });

    posting.fail(function( ) {
        $( "#result" ).empty().append( "Erro ao cadastrar unidade consumidora." );
        $( "#result" ).removeClass("text-success")
        $( "#result" ).addClass("text-danger")
        $( "#result" ).css("display", "block")
    });
})