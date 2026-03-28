const Team = require("../models/Team");
const User = require("../models/User");
const createInviteCode = require("../utils/inviteCode");

const createTeam = async (req, res) => {
  const { name } = req.body;
  if (!name) {
    return res.status(400).json({ message: "Team name is required" });
  }

  const freshUser = await User.findById(req.user._id);
  if (freshUser.team) {
    return res.status(400).json({ message: "User already belongs to a team" });
  }

  const team = await Team.create({
    name,
    leader: req.user._id,
    members: [req.user._id],
    inviteCode: createInviteCode(),
  });

  freshUser.team = team._id;
  freshUser.teamRole = "leader";
  await freshUser.save();

  return res.status(201).json({
    team,
    inviteLink: `${process.env.CLIENT_BASE_URL || "dfto://join"}/team/${team.inviteCode}`,
  });
};

const joinTeam = async (req, res) => {
  const { inviteCode } = req.params;
  const user = await User.findById(req.user._id);

  if (user.team) {
    return res.status(400).json({ message: "User already belongs to a team" });
  }

  const team = await Team.findOne({ inviteCode });
  if (!team) {
    return res.status(404).json({ message: "Invalid invite code" });
  }

  team.members.push(user._id);
  await team.save();

  user.team = team._id;
  user.teamRole = "member";
  await user.save();

  return res.json({ message: "Joined team successfully", team });
};

const getMyTeam = async (req, res) => {
  const user = await User.findById(req.user._id);
  if (!user.team) {
    return res.status(404).json({ message: "User is not in a team" });
  }

  const team = await Team.findById(user.team)
    .populate("leader", "name email points")
    .populate("members", "name email points teamRole");

  return res.json({ team });
};

const getTeamById = async (req, res) => {
  const team = await Team.findById(req.params.teamId)
    .populate("leader", "name email points")
    .populate("members", "name email points teamRole");

  if (!team) {
    return res.status(404).json({ message: "Team not found" });
  }

  const isMember = team.members.some((member) => member._id.toString() === req.user._id.toString());
  if (!isMember) {
    return res.status(403).json({ message: "Forbidden" });
  }

  return res.json({ team });
};

const getLeaderboard = async (req, res) => {
  const team = await Team.findById(req.params.teamId).populate("members", "name points teamRole");
  if (!team) {
    return res.status(404).json({ message: "Team not found" });
  }

  const isMember = team.members.some((member) => member._id.toString() === req.user._id.toString());
  if (!isMember) {
    return res.status(403).json({ message: "Forbidden" });
  }

  const leaderboard = [...team.members].sort((a, b) => b.points - a.points);
  return res.json({ leaderboard });
};

module.exports = {
  createTeam,
  joinTeam,
  getMyTeam,
  getTeamById,
  getLeaderboard,
};
