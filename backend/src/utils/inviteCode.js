const crypto = require("crypto");

const createInviteCode = () => crypto.randomBytes(8).toString("hex");

module.exports = createInviteCode;
