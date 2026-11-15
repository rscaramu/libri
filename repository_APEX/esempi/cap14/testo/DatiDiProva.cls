public class DatiDiProva {

    public static void crea() {
        List<Account> az = new List<Account>{
            azienda('Officine Riva', 'Manufacturing',
                'Bari', 2500000, 48, 'Hot'),
            azienda('Tecno Sud', 'Technology',
                'Lecce', 800000, 12, 'Warm'),
            azienda('Energia Blu', 'Energy',
                'Torino', 12000000, 210, 'Hot'),
            azienda('Trasporti Neri', 'Transportation',
                'Milano', 4300000, 95, 'Cold'),
            azienda('Agricola Verde', 'Agriculture',
                'Bari', 650000, 9, null)
        };
        insert az;
        insert new List<Contact>{
            persona('Anna', 'Conti', 'Buyer', az[0].Id),
            persona('Luca', 'Riva', 'Titolare', az[0].Id),
            persona('Sara', 'Neri', 'Resp. IT', az[1].Id),
            persona('Piero', 'Sala', 'Dir. tecnico',
                az[2].Id),
            persona('Marta', 'Greco', 'Buyer', az[2].Id),
            persona('Ugo', 'Tosi', 'Titolare', az[3].Id),
            persona('Elena', 'Bassi', 'Consulente', null)
        };
        insert new List<Opportunity>{
            affare('Fornitura viti', az[0].Id,
                'Prospecting', 18000, 30),
            affare('Linea imballaggio', az[0].Id,
                'Closed Won', 95000, -20),
            affare('Portale clienti', az[1].Id,
                'Negotiation/Review', 32000, 15),
            affare('Impianto fotovoltaico', az[2].Id,
                'Closed Won', 240000, -60),
            affare('Manutenzione turbine', az[2].Id,
                'Proposal/Price Quote', 75000, 45),
            affare('Rinnovo flotta', az[3].Id,
                'Closed Lost', 130000, -10)
        };
    }

    private static Account azienda(String nome,
            String settore, String citta,
            Decimal fatturato, Integer addetti,
            String valutazione) {
        return new Account(Name = nome,
            Industry = settore, BillingCity = citta,
            BillingCountry = 'Italia',
            AnnualRevenue = fatturato,
            NumberOfEmployees = addetti,
            Rating = valutazione);
    }

    private static Contact persona(String nome,
            String cognome, String ruolo, Id azienda) {
        return new Contact(FirstName = nome,
            LastName = cognome, Title = ruolo,
            AccountId = azienda,
            MailingCountry = 'Italia',
            Email = nome.toLowerCase() + '.'
                + cognome.toLowerCase() + '@esempio.it');
    }

    private static Opportunity affare(String nome,
            Id azienda, String fase, Decimal importo,
            Integer giorni) {
        return new Opportunity(Name = nome,
            AccountId = azienda, StageName = fase,
            Amount = importo,
            CloseDate = Date.today().addDays(giorni));
    }

    public static void rimuovi() {
        delete [SELECT Id FROM Contact
            WHERE MailingCountry = 'Italia'];
        delete [SELECT Id FROM Account
            WHERE BillingCountry = 'Italia'];
    }
}
