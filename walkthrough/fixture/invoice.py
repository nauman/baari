import csv
import io


def export_csv(invoice):
    output = io.StringIO(newline="")
    writer = csv.writer(output)
    writer.writerow(["invoice_id", "amount_cents"])
    writer.writerow([invoice["id"], invoice["amount_cents"]])
    return output.getvalue()


def download_invoice(customer_id, invoice):
    if invoice["customer_id"] != customer_id:
        raise PermissionError("invoice belongs to another customer")
    return export_csv(invoice)
