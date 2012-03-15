
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.sendfile(req.app.set('views') + '/index.html');
};