-- Create increment_unread_and_touch RPC to prevent racy read-modify-write on unread_count
CREATE OR REPLACE FUNCTION public.increment_unread_and_touch(
  p_conversation_id UUID,
  p_last_message_text TEXT,
  p_last_message_at TIMESTAMPTZ,
  p_updated_at TIMESTAMPTZ
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE conversations
  SET 
    last_message_text = p_last_message_text,
    last_message_at = p_last_message_at,
    unread_count = COALESCE(unread_count, 0) + 1,
    updated_at = p_updated_at
  WHERE id = p_conversation_id;
END;
$$;
