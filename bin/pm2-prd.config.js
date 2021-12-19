/**
 * @description pm2 配置文件，线上环境
 * @author 铁铁
 */

const appConf = require('./pm2AppConf');

module.exports = {
  apps: [appConf],
};
