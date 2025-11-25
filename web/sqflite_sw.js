'use strict';

// sqflite_common_ffi_web service worker

self.importScripts('sql-wasm.js');

let db = null;

self.onmessage = async function (event) {
  const data = event.data;

  switch (data['method']) {
    case 'open':
      if (!db) {
        const config = {
          locateFile: file => 'sql-wasm.wasm'
        };
        const SQL = await initSqlJs(config);
        db = new SQL.Database();
      }
      self.postMessage({ 'result': true, 'id': data['id'] });
      break;

    case 'execute':
      try {
        const result = db.exec(data['sql']);
        self.postMessage({ 'result': result, 'id': data['id'] });
      } catch (e) {
        self.postMessage({ 'error': e.toString(), 'id': data['id'] });
      }
      break;

    case 'close':
      db = null;
      self.postMessage({ 'result': true, 'id': data['id'] });
      break;
  }
};
