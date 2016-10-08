import table_sync as a

con_s = dict(user='root', password='server', database='profit',host='localhost')
con_t = dict(user='root', password='server', database='akuntan',host='localhost')

field_history_local  = "kd_perusahaan, kd_kiraan, tahun, bulan, saldo_awal, debet, kredit"
field_history_server = "perusahaan_id, kiraan_id, tahun, bulan, saldo_awal, debit, kredit"

field_jurnal_local  = "kd_perusahaan, no_ix, tgl, keterangan, no_refrensi, refr, nilai"
field_jurnal_server = "perusahaan_id, id, tanggal, keterangan, referensi, jenis, nilai"

field_jurdet_local  = "kd_perusahaan, ix_jurnal, no_urut, kd_akun, debet, kredit, rujukan"
field_jurdet_server = "perusahaan_id, jurnal_id, urut, kiraan_id, debit, kredit, rujukan"

s_history = a.Table(con_s, field_history_local, "tb_jurnal_history")
t_history = a.Table(con_t, field_history_server, "jurnal_sejarahs")

s_jurnal = a.Table(con_s, field_jurnal_local, "tb_jurnal_global")
t_jurnal = a.Table(con_t, field_jurnal_server, "jurnals")

s_jurdet = a.Table(con_s, field_jurdet_local, "tb_jurnal_rinci")
t_jurdet = a.Table(con_t, field_jurdet_server, "jurnal_details")

a.sync(s_history,t_history)
a.sync(s_jurnal, t_jurnal)
a.sync(s_jurdet, t_jurdet)