module.exports = cds.service.impl(async function () {
  //it will look our Catelogservice.cds file and get
  //the object of the corresponding entity so that we can
  //tell capm which entity i want to add generic handler
  const { EmployeeSet, POs } = this.entities;

  this.before(["UPDATE", "CREATE"], EmployeeSet, (req, res) => {
    console.log("varuthu " + JSON.stringify(req.data));
    var jsonData = req.data;
    if (jsonData.hasOwnProperty("salaryAmount")) {
      const salary = parseFloat(req.data.salaryAmount);
      if (salary > 10000) {
        req.error(500, "Bro, The salary Amount can not be more than 10000 ");
      }
    }
  });

  this.after("READ", EmployeeSet, (req, res) => {
    console.log(JSON.stringify(res));
    var finalData = [];
    for (let i = 0; i < res.results.length; i++) {
      const element = res.results[i];
      element.salaryAmount = element.salaryAmount * 1.1;
      finalData.push(element);
    }
    finalData.push({
      ID: "dummy",
      nameFirst: "Michale",
      nameLast: "Saylor",
    });
    res.results = finalData;
  });

  //Implementation for the function
  this.on("getMostExpensiveOrder", async (req, res) => {
    try {
      const tx = cds.tx(req);
      const myData = await tx
        .read(POs)
        .orderBy({
          GROSS_AMOUNT: "desc",
        })
        .limit(1);
      return myData;
    } catch (error) {
      return "Hey vijay !" + error.toString();
    }
  });

  this.on('getOrderDefault', async (req, res) => {
    try {
      return {OVERALL_STATUS: 'N'}
    } catch (error) {
      return "Hey vijay !" + error.toString();
    }

  });

  //instance based Action
  this.on('boost', async (req, res) => {
    try {
      //Programmatically check @runtime, if the user have the editor permission
      req.user.is('Editor') || req.reject(403)
      const POID = req.params[0];
      console.log("Bro your PO ID was " + JSON.stringify(POID));
      const tx = cds.tx(req);
      await tx
        .update(POs)
        .with({
          "GROSS_AMOUNT": { "+=": 20000 },
        })
        .where(POID);
      //After modify read the instance
      const reply = tx.read(POs).where(POID);
      return reply;
    } catch (error) {
      return "Hi Vijay !" + error.toString();
    }
  });

  this.on('setDelivered', async (req, res) => {
    try {
      const POID = req.params[0];
      console.log("Bro your PO ID was " + JSON.stringify(POID));
      const tx = cds.tx(req);
      await tx
        .update(POs)
        .with({
          "OVERALL_STATUS": 'D',
        })
        .where(POID);
      //After modify read the instance
      const reply = tx.read(POs).where(POID);
      return reply;
    } catch (error) {
      return "Hi Vijay !" + error.toString();
    }
  });


});
