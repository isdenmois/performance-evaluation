function renderChart(selector, title, axisX, points) {
    var chart = new CanvasJS.Chart(selector, {
      title: {
        text: title
      },
      data: [
        {
          color: "#009688",
          type: points.length < 30 ? "column" : "line",
          dataPoints: points
        }
      ],
      axisY: {
        title: 'Вероятность'
      },
      axisX: {
        title: axisX
      }
    });

    chart.render()
}
