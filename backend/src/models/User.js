const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true },
    password: { type: String, required: true, minlength: 6 },
    points: { type: Number, default: 0 },
    team: { type: mongoose.Schema.Types.ObjectId, ref: "Team", default: null },
    teamRole: {
      type: String,
      enum: ["none", "leader", "member"],
      default: "none",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", userSchema);
