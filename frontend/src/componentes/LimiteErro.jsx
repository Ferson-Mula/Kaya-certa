import React from "react";

export default class LimiteErro extends React.Component {
  constructor(props) {
    super(props);
    this.state = { temErro: false, erro: null };
  }

  static getDerivedStateFromError(erro) {
    return { temErro: true, erro };
  }

  componentDidCatch(erro, info) {
    console.error("Erro na interface capturado pelo LimiteErro:", erro, info);
  }

  render() {
    if (this.state.temErro) {
      return (
        <div style={{ padding: 40, maxWidth: 600, margin: "60px auto", textAlign: "center", background: "#fff", borderRadius: 12, boxShadow: "0 4px 20px rgba(0,0,0,0.08)" }}>
          <h2 style={{ color: "#e11d48", marginBottom: 12, fontSize: 20 }}>Ocorreu um erro na interface</h2>
          <p style={{ color: "#64748b", marginBottom: 24, fontSize: 14 }}>
            {this.state.erro?.message || "Ocorreu uma falha temporária ao renderizar este ecrã."}
          </p>
          <button
            type="button"
            onClick={() => {
              this.setState({ temErro: false, erro: null });
              window.location.href = "/";
            }}
            style={{ padding: "10px 24px", background: "#0284c7", color: "#fff", border: "none", borderRadius: 8, cursor: "pointer", fontWeight: 600, fontSize: 14 }}
          >
            Recarregar Página Inicial
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}
