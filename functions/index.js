// Cloud Function: generateBillNumber
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const cors = require('cors')({origin:true});

admin.initializeApp();
const db = admin.firestore();

exports.generateBillNumber = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const now = new Date();
      const yyyy = now.getFullYear();
      const mm = String(now.getMonth() + 1).padStart(2,'0');
      const monthKey = `${yyyy}-${mm}`;
      const metaRef = db.collection('metadata').doc('billing');

      const result = await db.runTransaction(async (tx) => {
        const doc = await tx.get(metaRef);
        let data = doc.exists ? doc.data() : {};
        let lastMonth = data && data.lastMonth ? data.lastMonth : null;
        let seq = data && data.lastSeq ? data.lastSeq : 0;
        if (lastMonth !== monthKey) seq = 1; else seq = seq + 1;
        tx.set(metaRef, { lastMonth: monthKey, lastSeq: seq }, { merge: true });
        const seqStr = String(seq).padStart(3,'0');
        const billNo = `RMW-${yyyy}-${mm}-${seqStr}`;
        return { billNo, seq, year: yyyy, month: parseInt(mm,10) };
      });

      res.status(200).json(result);
    } catch (err) {
      console.error(err);
      res.status(500).json({error: String(err)});
    }
  });
});
