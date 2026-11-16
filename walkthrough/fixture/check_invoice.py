import csv
import io
import unittest
from invoice import download_invoice


class InvoiceDownload(unittest.TestCase):
    def setUp(self):
        self.invoice = {"id": "INV-17", "customer_id": "customer-a", "amount_cents": 4200}

    def test_owner_gets_csv(self):
        rows = list(csv.DictReader(io.StringIO(download_invoice("customer-a", self.invoice))))
        self.assertEqual(rows, [{"invoice_id": "INV-17", "amount_cents": "4200"}])

    def test_other_customer_is_rejected(self):
        with self.assertRaises(PermissionError):
            download_invoice("customer-b", self.invoice)


if __name__ == "__main__":
    unittest.main(verbosity=2)
