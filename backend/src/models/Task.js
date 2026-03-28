const mongoose = require("mongoose");

const taskSchema = new mongoose.Schema(
  {
    type: { type: String, enum: ["personal", "team"], required: true },
    title: { type: String, required: true, trim: true },
    description: { type: String, default: "" },
    assignedTo: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    team: { type: mongoose.Schema.Types.ObjectId, ref: "Team", default: null },
    status: {
      type: String,
      enum: ["pending", "completed", "approved"],
      default: "pending",
    },
    points: { type: Number, default: 0, min: 0 },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Task", taskSchema);
