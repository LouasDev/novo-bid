const express = require("express");
const pool = require("../config/database");
const { autenticar } = require("../middlewares/auth");

const router = express.Router();
router.use(autenticar);

router.get("/", async (_req, res) => {
  try {
    const [[orgaos]] = await pool.query("SELECT COUNT(*) total FROM orgaos");
    const [[medicamentos]] = await pool.query("SELECT COUNT(*) total FROM medicamentos");
    const [[abertas]] = await pool.query("SELECT COUNT(*) total FROM licitacoes WHERE status IN ('Edital aberto','Proposta enviada','Em análise')");
    const [[ativos]] = await pool.query("SELECT COALESCE(SUM(valor_contratado),0) total FROM contratos WHERE status='Ativo'");
    const [proximas] = await pool.query(`SELECT l.*, o.nome orgao_nome, m.nome medicamento_nome FROM licitacoes l JOIN orgaos o ON o.id=l.orgao_id JOIN medicamentos m ON m.id=l.medicamento_id WHERE l.status NOT IN ('Concluída','Cancelada') ORDER BY l.prazo_proposta LIMIT 6`);
    const [porMes] = await pool.query("SELECT DATE_FORMAT(prazo_proposta, '%Y-%m') mes, COUNT(*) total FROM licitacoes WHERE prazo_proposta >= DATE_SUB(CURDATE(), INTERVAL 5 MONTH) GROUP BY mes ORDER BY mes");

    res.json({
      totais: {
        orgaos: orgaos.total, medicamentos: medicamentos.total, abertas: abertas.total, ativos: ativos.total
      },
      proximas,
      porMes,
    });
  } catch (erro) {
    console.error(erro);
    res.status(500).json({ mensagem: "Erro ao carregar o painel." });
  }
});

module.exports = router;
