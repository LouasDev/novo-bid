const express = require("express");
const pool = require("../config/database");
const { autenticar, apenasAdmin } = require("../middlewares/auth");
const router = express.Router();
router.use(autenticar);

router.get("/", async (_req, res) => {
  try {
    const [dados] = await pool.query(`SELECT o.*, COUNT(l.id) total_licitacoes FROM orgaos o LEFT JOIN licitacoes l ON l.orgao_id=o.id GROUP BY o.id ORDER BY o.nome`);
    res.json(dados);
  } catch { res.status(500).json({ mensagem: "Erro ao listar órgãos." }); }
});
router.post("/", async (req, res) => {
  const { nome, cnpj, cidade, uf, contato, email } = req.body;
  if (!nome || !cnpj) return res.status(400).json({ mensagem: "Nome e CNPJ são obrigatórios." });
  try { const [r] = await pool.query("INSERT INTO orgaos (nome,cnpj,cidade,uf,contato,email) VALUES (?,?,?,?,?,?)", [nome,cnpj,cidade||null,uf||null,contato||null,email||null]); res.status(201).json({ id:r.insertId, mensagem:"Órgão cadastrado." }); }
  catch (e) { res.status(e.code === "ER_DUP_ENTRY" ? 409 : 500).json({ mensagem: e.code === "ER_DUP_ENTRY" ? "Este CNPJ já está cadastrado." : "Erro ao cadastrar órgão." }); }
});
router.put("/:id", async (req,res) => { const {nome,cnpj,cidade,uf,contato,email}=req.body; try { const [r]=await pool.query("UPDATE orgaos SET nome=?,cnpj=?,cidade=?,uf=?,contato=?,email=? WHERE id=?",[nome,cnpj,cidade||null,uf||null,contato||null,email||null,req.params.id]); if(!r.affectedRows)return res.status(404).json({mensagem:"Órgão não encontrado."}); res.json({mensagem:"Órgão atualizado."}); } catch {res.status(500).json({mensagem:"Erro ao atualizar órgão."});} });
router.delete("/:id", apenasAdmin, async (req,res) => { try {const[r]=await pool.query("DELETE FROM orgaos WHERE id=?",[req.params.id]);if(!r.affectedRows)return res.status(404).json({mensagem:"Órgão não encontrado."});res.json({mensagem:"Órgão excluído."});}catch{res.status(409).json({mensagem:"Este órgão possui licitações vinculadas."});} });
module.exports = router;
