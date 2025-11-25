// sql.js loader (required by sqflite_common_ffi_web)

var initSqlJs = (function () {
  var scriptDir = '';
  return function (options) {
    if (!options) options = {};
    if (!options.locateFile) {
      options.locateFile = filename => scriptDir + filename;
    }
    return new Promise((resolve, reject) => {
      try {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', options.locateFile('sql-wasm.wasm'), true);
        xhr.responseType = 'arraybuffer';

        xhr.onload = function () {
          if (xhr.status !== 200) {
            reject(new Error('Failed to load wasm: ' + xhr.status));
            return;
          }

          WebAssembly.instantiate(xhr.response).then(result => {
            resolve({
              Database: function () {
                this.exec = sql => {
                  const stmt = result.instance.exports.prepare(sql);
                  const rows = [];
                  let row;
                  while ((row = result.instance.exports.step(stmt))) {
                    rows.push(row);
                  }
                  return rows;
                };
              }
            });
          });
        };

        xhr.send(null);

      } catch (e) {
        reject(e);
      }
    });
  };
})();
