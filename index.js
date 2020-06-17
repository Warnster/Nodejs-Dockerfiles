// quit on ctrl-c when running docker in terminal
process.on('SIGINT', function onSigint() {
	console.info('Got SIGINT (aka ctrl-c in docker). Graceful shutdown');
	shutdown();
}) 

//quit properly on docker stop
process.on('SIGTERM', function onSigterm() {
	console.info('Got SIGTERM (docker container stop). Graceful shutdown');
	shutdown();
})

//shut down server
function shutdown() {
	server.close(function onServerClosed(err) {
		if (err) {
			console.error(err)
			process.exitCode = 1; 
		}
		process.exit();
	})
}