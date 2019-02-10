   
function updateModel(modelId) {
    $(".select-battery").css('display', 'none');
    if (modelId) {
        var model = vehicleModels[modelId-1]

        $("#form-battery").css('display', 'block');
        $("#select-battery-"+model.id).css('display', 'block');

        $("#modelId").val(model.id)
        $("#make").val(model.make)
        $("#model").val(model.model)
    } else {
        $("#form-battery").css('display', 'none');
        // $("#select-battery-"+modelId).css('display', 'none');
        
        $("#modelId").val(0)
        $("#make").val("")
        $("#model").val("")
    }
}

