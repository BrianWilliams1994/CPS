google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(getParentSafetyData);

function getParentSafetyData() {
    $.get('getcpsdata', function (data) {
        drawChart(data);
    });
}

function drawChart(parentSafetyData) {
    var dataArray = _.map(parentSafetyData, function(schoolString){
        var school = $.parseJSON(schoolString);
        return [school["safetyScore"], school["parentInvolvement"]];
    });

    dataArray.unshift(["Parent Involvement" , "Safety Score"])

    var realData = google.visualization.arrayToDataTable(dataArray);

    var options = {
        title:"Parent Involvement Vs.Safety Score",
        hAxis:{title:"Parent Involvement", minValue:0, maxValue:100},
        vAxis:{title:"Safety Score", minValue:0, maxValue:100},
        width: 1000,
        height: 1000
    };

    var chart = new google.visualization.ScatterChart(document.getElementById("chart"));
    chart.draw(realData, options);
}