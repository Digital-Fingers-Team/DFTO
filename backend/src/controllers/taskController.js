const Task = require("../models/Task");
const Team = require("../models/Team");
const User = require("../models/User");

const createPersonalTask = async (req, res) => {
  const { title, description } = req.body;
  if (!title) {
    return res.status(400).json({ message: "Task title is required" });
  }

  const task = await Task.create({
    type: "personal",
    title,
    description: description || "",
    assignedTo: req.user._id,
    createdBy: req.user._id,
    points: 0,
  });

  return res.status(201).json({ task });
};

const getPersonalTasks = async (req, res) => {
  const tasks = await Task.find({ type: "personal", assignedTo: req.user._id }).sort({ createdAt: -1 });
  return res.json({ tasks });
};

const createTeamTask = async (req, res) => {
  const { teamId, title, description, assignedTo, points } = req.body;
  if (!teamId || !title || !assignedTo) {
    return res.status(400).json({ message: "teamId, title and assignedTo are required" });
  }

  const team = await Team.findById(teamId);
  if (!team) {
    return res.status(404).json({ message: "Team not found" });
  }

  if (team.leader.toString() !== req.user._id.toString()) {
    return res.status(403).json({ message: "Only leader can assign team tasks" });
  }

  const isMember = team.members.some((m) => m.toString() === assignedTo);
  if (!isMember) {
    return res.status(400).json({ message: "Assigned user must be in the team" });
  }

  const task = await Task.create({
    type: "team",
    team: team._id,
    title,
    description: description || "",
    assignedTo,
    createdBy: req.user._id,
    points: Number(points || 0),
  });

  return res.status(201).json({ task });
};

const getTeamTasks = async (req, res) => {
  const { teamId } = req.params;
  const team = await Team.findById(teamId);
  if (!team) {
    return res.status(404).json({ message: "Team not found" });
  }

  const isMember = team.members.some((m) => m.toString() === req.user._id.toString());
  if (!isMember) {
    return res.status(403).json({ message: "Forbidden" });
  }

  const tasks = await Task.find({ type: "team", team: teamId })
    .populate("assignedTo", "name email")
    .sort({ createdAt: -1 });

  return res.json({ tasks });
};

const markTaskCompleted = async (req, res) => {
  const task = await Task.findById(req.params.taskId);
  if (!task) {
    return res.status(404).json({ message: "Task not found" });
  }

  if (task.assignedTo.toString() !== req.user._id.toString()) {
    return res.status(403).json({ message: "Only assignee can complete the task" });
  }

  if (task.status === "approved") {
    return res.status(400).json({ message: "Task already approved" });
  }

  task.status = "completed";
  await task.save();
  return res.json({ task });
};

const approveTask = async (req, res) => {
  const task = await Task.findById(req.params.taskId);
  if (!task) {
    return res.status(404).json({ message: "Task not found" });
  }

  if (task.type !== "team") {
    return res.status(400).json({ message: "Only team tasks require approval" });
  }

  const team = await Team.findById(task.team);
  if (!team) {
    return res.status(404).json({ message: "Team not found" });
  }

  if (team.leader.toString() !== req.user._id.toString()) {
    return res.status(403).json({ message: "Only leader can approve tasks" });
  }

  if (task.status !== "completed") {
    return res.status(400).json({ message: "Task must be completed first" });
  }

  task.status = "approved";
  await task.save();

  const assignee = await User.findById(task.assignedTo);
  assignee.points += task.points;
  await assignee.save();

  return res.json({ task, message: "Task approved and points awarded" });
};

module.exports = {
  createPersonalTask,
  getPersonalTasks,
  createTeamTask,
  getTeamTasks,
  markTaskCompleted,
  approveTask,
};
