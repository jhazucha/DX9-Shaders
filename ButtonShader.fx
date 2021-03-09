float Alpha;
bool IsSelected;

texture btnTexture;

struct VertexShaderOutput
{
  float4 Position : POSITION0;
  float2 TexCoord : TEXCOORD0;
};

sampler2D samp1 : TEXUNIT0 = sampler_state
{
  Texture	  = (btnTexture);
  MipFilter = LINEAR;
  MagFilter = LINEAR;
  MinFilter = LINEAR;
};

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
  float4 final = tex2D(samp1, input.TexCoord);
	
	final.a *= Alpha;
	
  return final;
}

technique Technique1
{
  pass Pass1
  {
    PixelShader = compile ps_2_0 PixelShaderFunction();
  }
}
