   
var vehicle = {
    modelId: 0,
    make: "",
    model: "",
    battery: 0,
    licensePlate: "",
    charge: 100
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
   
    // Get some values from elements on the page:
    var modelId = $("#modelId").val()
    var make = $("#make").val()
    var model = $("#model").val()
    var battery = $("#battery").val()
    var licensePlate = $("#inputLicense").val()

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
