using System;
using System.Data.Entity.Core.Objects;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebAPIAssignment.Models;

namespace WebAPIAssignment.Controllers
{
    public class BankCardController : ApiController
    {
        private AssignmentBankEntities dbEntity = new AssignmentBankEntities();

        [Route("api/validatecard/{cardno}/{expirydate}")]
        public dynamic ValidateBankCard(string cardno, string expirydate)
        {
            try
            {
                //if bankcard contain '-', remove
                cardno = cardno.Replace("-", "");

                ObjectParameter oparaResult = new ObjectParameter("Result", typeof(string));
                ObjectParameter oparaCardtype = new ObjectParameter("CardType", typeof(string));
                dbEntity.usp_ValidateBankCard(cardno, expirydate, oparaResult, oparaCardtype);

                var Message = Request.CreateResponse(HttpStatusCode.OK, new { result = oparaResult.Value.ToString(), CardType = oparaCardtype.Value.ToString() });
                return Message;
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, ex.Message);
            }
        }

    }
}
