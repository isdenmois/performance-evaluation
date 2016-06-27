function firstResult(r) {
	r = JSON.parse(r);
	$('.result.hidden').removeClass('hidden');
	renderChart('length', 'Распределение длины очереди', 'Длина очереди', r.length);
	renderChart('pbusy', 'Распределение времени непрерывной занятости', 'Время', r.pbusy);
	$('#time-mod').html(r.time);
	$('#correlation').html(r.correlation);
}

function computeFirst(e) {
	e.preventDefault();

	var time = $('#time', this).val();
	var lambda = $('#lambda', this).val();
	var sigma = $('#sigma', this).val();
	var mu = $('#mu', this).val();

	PVIface.computeFirst(time, lambda, mu, sigma, firstResult);
}

$(window).load(function() {
	$('#first-form').submit(computeFirst);
});
