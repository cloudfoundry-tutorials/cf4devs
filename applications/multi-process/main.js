var http = require('http');
var sleep = require('sleep');

const fib = () => {
	console.log('Calculating the Fibonacci sequence...');
	let [f0, f1] = [0, 1];

	while (true) {
		const sum = f0 + f1;

		f0 = f1;
		f1 = sum;

		console.log(f0);
		sleep.sleep(1);
	}
};

switch (process.argv[process.argv.length - 1]) {
  case 'web':
    if (!process.env.PORT) {
      console.error("PORT environment variable not set");
      process.exit(1);
    }

    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end(`Hi, I love ${req.url.slice(1)}!\n`);
    }).listen(process.env.PORT, "0.0.0.0");

    console.log(`Server running at http://0.0.0.0:${process.env.PORT}/`);
    break;
  case 'worker':
    fib();
    break;
  default:
    console.error('please specify web or worker');
    process.exit(1);
};
