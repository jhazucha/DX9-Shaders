//*****************************************************************************
// The program and technique for performing the gaussian blur during the
// the bloom postprocessing effect.
//*****************************************************************************

sampler ScreenSampler : register( s0 );

#define BLUR_SAMPLE_COUNT 15
float2 SampleOffsets[BLUR_SAMPLE_COUNT];
float SampleWeights[BLUR_SAMPLE_COUNT];

//*****************************************************************************
// Blur Program.
float4 GaussianBlurPS( float2 texCoord : TEXCOORD0 ) : COLOR0
{
    float4 color = 0;
    
    // Combine a number of weighted image filter taps.
    for( int i = 0; i < BLUR_SAMPLE_COUNT; i++ )
    {
        color+= tex2D( ScreenSampler, texCoord + SampleOffsets[i] )*SampleWeights[i];
    }
    
    return color;
}

//*****************************************************************************
technique GaussianBlurTech
{
	pass P0
	{
		PixelShader = compile ps_2_0 GaussianBlurPS( );
	}
}