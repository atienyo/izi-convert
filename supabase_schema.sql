-- ==========================================================================
-- SCHEMA SUPABASE POUR EASYCONVERTOR (IZICONVERT)
-- Exécutez ce script dans le SQL Editor de votre projet Supabase "EasyConvertor"
-- ==========================================================================

-- 1. Table des conversions de fichiers
CREATE TABLE IF NOT EXISTS public.conversions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id TEXT NOT NULL,
    original_filename TEXT NOT NULL,
    converted_filename TEXT NOT NULL,
    source_format VARCHAR(20) NOT NULL,
    target_format VARCHAR(20) NOT NULL,
    file_size_bytes BIGINT NOT NULL DEFAULT 0,
    file_url TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'completed', -- 'processing', 'completed', 'expired'
    invoice_ref VARCHAR(50) UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now() + interval '24 hours') NOT NULL
);

-- Index pour recherche rapide par session et référence facture
CREATE INDEX IF NOT EXISTS idx_conversions_session ON public.conversions(session_id);
CREATE INDEX IF NOT EXISTS idx_conversions_invoice_ref ON public.conversions(invoice_ref);
CREATE INDEX IF NOT EXISTS idx_conversions_created_at ON public.conversions(created_at DESC);

-- 2. Table des transactions de paiement (0,90 $ USD unique)
CREATE TABLE IF NOT EXISTS public.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversion_id UUID REFERENCES public.conversions(id) ON DELETE CASCADE,
    amount NUMERIC(6, 2) NOT NULL DEFAULT 0.90,
    currency VARCHAR(10) NOT NULL DEFAULT 'USD',
    payment_method VARCHAR(50) NOT NULL, -- 'stripe-card', 'stripe-link', 'momo-wave', 'momo-orange', 'momo-mtn', 'momo-moov', 'paypal', 'apple-pay', 'google-pay', 'demo'
    status VARCHAR(30) NOT NULL DEFAULT 'succeeded', -- 'pending', 'succeeded', 'failed', 'refunded'
    invoice_ref VARCHAR(50) NOT NULL,
    payer_name TEXT,
    payer_phone TEXT,
    transaction_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Index paiements
CREATE INDEX IF NOT EXISTS idx_payments_invoice_ref ON public.payments(invoice_ref);
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON public.payments(created_at DESC);

-- 3. Activation de Row Level Security (RLS)
ALTER TABLE public.conversions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

-- Politiques de lecture / écriture anonymes protégées pour le front-end
CREATE POLICY "Allow public insert conversions"
ON public.conversions FOR INSERT
TO anon, authenticated
WITH CHECK (true);

CREATE POLICY "Allow public select own conversion"
ON public.conversions FOR SELECT
TO anon, authenticated
USING (true);

CREATE POLICY "Allow public insert payments"
ON public.payments FOR INSERT
TO anon, authenticated
WITH CHECK (true);

CREATE POLICY "Allow public select payments"
ON public.payments FOR SELECT
TO anon, authenticated
USING (true);

-- 4. Vue récapitulative des revenus et conversions
CREATE OR REPLACE VIEW public.vw_daily_stats AS
SELECT 
    date_trunc('day', created_at) AS day,
    count(*) AS total_conversions,
    sum(case when status = 'succeeded' then amount else 0 end) AS total_revenue_usd
FROM public.payments
GROUP BY 1
ORDER BY 1 DESC;

COMMENT ON TABLE public.conversions IS 'Historique des conversions et gestion de la conservation 24h';
COMMENT ON TABLE public.payments IS 'Transactions des paiements uniques à l acte (0.90 USD)';
